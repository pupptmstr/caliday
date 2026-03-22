import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Snapshot of a nearby CaliDay user discovered via BLE scan.
class NearbyDevice {
  const NearbyDevice({
    required this.deviceId,
    required this.localName,
    required this.rssi,
  });

  final String deviceId;
  final String localName;
  final int rssi;
}

/// Manages BLE discovery of nearby CaliDay users.
///
/// Central role only (scanning + GATT client).
/// Advertising (Peripheral role) is not yet implemented — it requires a
/// dedicated peripheral-mode package or a native platform channel.
class BleService {
  static final instance = BleService._();
  BleService._();

  // Custom service UUID that identifies a CaliDay peer device.
  static const _serviceUuid = 'ca11da00-0000-0000-0000-000000000001';

  // Characteristic UUID that carries the profile JSON (read-only).
  static const _profileCharUuid = 'ca11da00-0000-0000-0000-000000000002';

  final _nearbyController = StreamController<List<NearbyDevice>>.broadcast();

  /// Stream of nearby CaliDay devices updated during an active scan.
  Stream<List<NearbyDevice>> get nearbyStream => _nearbyController.stream;

  final _found = <String, NearbyDevice>{};
  StreamSubscription? _scanSub;

  bool get isBluetoothOn =>
      FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on;

  /// Start a 30-second BLE scan for CaliDay peer devices.
  Future<void> startDiscovery() async {
    if (!isBluetoothOn) {
      _nearbyController.add([]);
      return;
    }
    _found.clear();
    _nearbyController.add([]);

    try {
      await FlutterBluePlus.startScan(
        withServices: [Guid(_serviceUuid)],
        timeout: const Duration(seconds: 30),
      );
    } catch (_) {
      return;
    }

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        _found[r.device.remoteId.str] = NearbyDevice(
          deviceId: r.device.remoteId.str,
          localName: r.advertisementData.advName.isNotEmpty
              ? r.advertisementData.advName
              : r.device.remoteId.str,
          rssi: r.rssi,
        );
      }
      if (!_nearbyController.isClosed) {
        _nearbyController.add(List.from(_found.values));
      }
    });
  }

  void stopDiscovery() {
    FlutterBluePlus.stopScan();
    _scanSub?.cancel();
    _scanSub = null;
  }

  /// Attempt to read a [FriendProfile] from a nearby device via GATT.
  ///
  /// Returns null if the connection or characteristic read fails.
  /// This only works when the remote device has a GATT server set up
  /// (i.e., it is running CaliDay with peripheral advertising enabled).
  Future<Map<String, dynamic>?> readProfileJson(NearbyDevice nearby) async {
    final device =
        BluetoothDevice(remoteId: DeviceIdentifier(nearby.deviceId));
    try {
      await device.connect(timeout: const Duration(seconds: 10));
      final services = await device.discoverServices();
      for (final service in services) {
        if (service.uuid == Guid(_serviceUuid)) {
          for (final char in service.characteristics) {
            if (char.uuid == Guid(_profileCharUuid) &&
                char.properties.read) {
              final bytes = await char.read();
              await device.disconnect();
              // Caller is responsible for parsing bytes → JSON → FriendProfile
              return {'_raw': String.fromCharCodes(bytes)};
            }
          }
        }
      }
    } catch (_) {
      // ignore — GATT server not available on the remote side
    }
    try {
      await device.disconnect();
    } catch (_) {}
    return null;
  }

  // TODO: implement startAdvertising + GATT server via platform channel
  // or the ble_peripheral package so that other devices can discover us.
  Future<void> startAdvertising(
      String peerId, String displayName) async {}
  void stopAdvertising() {}
}