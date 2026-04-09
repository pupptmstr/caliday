import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ble_peripheral/ble_peripheral.dart' as blep;
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

/// Manages BLE Central (scan + GATT client) and Peripheral (advertising +
/// GATT server) roles for CaliDay peer discovery and profile exchange.
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

  bool _peripheralInitialized = false;

  // Latest profile JSON bytes to serve over GATT READ.
  Uint8List _profileBytes = Uint8List(0);

  bool get isBluetoothOn =>
      FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on;

  // ── Central: scan ────────────────────────────────────────────────────────

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

  // ── Central: GATT client ─────────────────────────────────────────────────

  /// Attempt to read a profile from a nearby device via GATT.
  ///
  /// Returns parsed JSON map on success, null if the remote has no GATT server
  /// or if the connection fails.
  Future<Map<String, dynamic>?> readProfileJson(NearbyDevice nearby) async {
    final device =
        BluetoothDevice(remoteId: DeviceIdentifier(nearby.deviceId));
    try {
      await device.connect(license: License.free, timeout: const Duration(seconds: 10));
      final services = await device.discoverServices();
      for (final service in services) {
        if (service.uuid == Guid(_serviceUuid)) {
          for (final char in service.characteristics) {
            if (char.uuid == Guid(_profileCharUuid) &&
                char.properties.read) {
              final bytes = await char.read();
              await device.disconnect();
              final raw = utf8.decode(bytes);
              return jsonDecode(raw) as Map<String, dynamic>;
            }
          }
        }
      }
    } catch (_) {
      // GATT server not available on the remote side — caller will fall back to QR
    }
    try {
      await device.disconnect();
    } catch (_) {}
    return null;
  }

  // ── Peripheral: advertising + GATT server ────────────────────────────────

  /// Start BLE advertising so nearby CaliDay users can discover this device.
  ///
  /// [profileJson] is the same map used for QR payloads (keys: v, id, name,
  /// sp, streak, longestStreak, rank, stages, date). It is serialised to UTF-8
  /// and served over GATT READ on the profile characteristic.
  Future<void> startAdvertising(
      Map<String, dynamic> profileJson, String displayName) async {
    if (!isBluetoothOn) return;

    _profileBytes = Uint8List.fromList(utf8.encode(jsonEncode(profileJson)));

    try {
      if (!_peripheralInitialized) {
        await blep.BlePeripheral.initialize();
        _peripheralInitialized = true;
      }

      await blep.BlePeripheral.clearServices();

      await blep.BlePeripheral.addService(
        blep.BleService(
          uuid: _serviceUuid,
          primary: true,
          characteristics: [
            blep.BleCharacteristic(
              uuid: _profileCharUuid,
              properties: [blep.CharacteristicProperties.read.index],
              permissions: [blep.AttributePermissions.readable.index],
              value: _profileBytes,
            ),
          ],
        ),
      );

      blep.BlePeripheral.setReadRequestCallback(
          (String deviceId, String characteristicId, int offset,
              Uint8List? value) {
        if (characteristicId.toLowerCase() ==
            _profileCharUuid.toLowerCase()) {
          return blep.ReadRequestResult(value: _profileBytes);
        }
        return blep.ReadRequestResult(value: Uint8List(0));
      });

      await blep.BlePeripheral.startAdvertising(
        services: [_serviceUuid],
        localName: displayName,
      );
    } catch (_) {
      // Advertising not supported or permission denied — silently skip
    }
  }

  /// Stop BLE advertising and remove the GATT service.
  Future<void> stopAdvertising() async {
    try {
      await blep.BlePeripheral.stopAdvertising();
      await blep.BlePeripheral.clearServices();
    } catch (_) {}
  }
}