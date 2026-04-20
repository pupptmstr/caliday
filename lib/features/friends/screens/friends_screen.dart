import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/services/ble_service.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/friend_profile.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../providers/friends_provider.dart';
import '../widgets/friend_detail_bottom_sheet.dart';
import 'qr_scan_screen.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  List<NearbyDevice> _nearby = [];
  StreamSubscription<List<NearbyDevice>>? _bleSub;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _ensurePeerId();
    _bleSub = BleService.instance.nearbyStream.listen((devices) {
      if (mounted) setState(() => _nearby = devices);
    });
    _startScan();
    _startAdvertising();
  }

  @override
  void dispose() {
    _bleSub?.cancel();
    BleService.instance.stopDiscovery();
    BleService.instance.stopAdvertising();
    super.dispose();
  }

  void _ensurePeerId() {
    final profile = ref.read(userRepositoryProvider).getProfile();
    if (profile.peerId?.isNotEmpty != true) {
      final rng = math.Random.secure();
      profile.peerId =
          List.generate(32, (_) => rng.nextInt(16).toRadixString(16)).join();
      profile.save();
    }
  }

  Future<void> _startScan() async {
    setState(() => _scanning = true);
    await BleService.instance.startDiscovery();
    if (mounted) setState(() => _scanning = false);
  }

  Future<void> _startAdvertising() async {
    final profile = ref.read(userRepositoryProvider).getProfile();
    if (profile.bleDiscoverable != true) return;
    final payload = _buildProfileJson();
    final name = (profile.displayName?.isNotEmpty == true)
        ? profile.displayName!
        : profile.rank.name;
    await BleService.instance.startAdvertising(payload, name);
  }

  Map<String, dynamic> _buildProfileJson() {
    final profile = ref.read(userRepositoryProvider).getProfile();
    final skillRepo = ref.read(skillProgressRepositoryProvider);
    final stages = {
      for (final b in BranchId.values)
        b.name: skillRepo.getProgress(b).currentStage,
    };
    return {
      'v': 1,
      'id': profile.peerId ?? '',
      'name': (profile.displayName?.isNotEmpty == true)
          ? profile.displayName
          : profile.rank.name,
      'sp': profile.totalSP,
      'streak': profile.currentStreak,
      'longestStreak': profile.longestStreak,
      'rank': profile.rank.index,
      'stages': stages,
      'date': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
  }

  Future<void> _connectViaBle(NearbyDevice device) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final json = await BleService.instance.readProfileJson(device);
    if (!mounted) return;

    if (json != null) {
      try {
        final friend = FriendProfile.fromBleJson(json);
        final isNew =
            await ref.read(friendsProvider.notifier).addOrUpdate(friend);
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(isNew ? l10n.friendsAdded : l10n.friendsUpdated),
            ),
          );
        }
        return;
      } catch (_) {
        // Malformed JSON — fall through to QR
      }
    }

    // Fallback: open QR scanner
    if (mounted) _openScanner(context);
  }

  String _buildQrPayload() {
    final data = _buildProfileJson();
    final encoded = base64Url.encode(utf8.encode(jsonEncode(data)));
    return 'caliday://friend?data=$encoded';
  }

  void _showMyQr(BuildContext context) {
    final payload = _buildQrPayload();
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.friendsMyQrTitle,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.friendsShareHint,
                style: TextStyle(
                    color: scheme.onSurfaceVariant, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: QrImageView(
                  data: payload,
                  version: QrVersions.auto,
                  size: 200,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  embeddedImage: const AssetImage('assets/icon/icon.png'),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(42, 42),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openScanner(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final result = await Navigator.of(context).push<FriendProfile>(
      MaterialPageRoute(builder: (_) => const QrScanScreen()),
    );
    if (result != null && mounted) {
      final isNew =
          await ref.read(friendsProvider.notifier).addOrUpdate(result);
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(isNew ? l10n.friendsAdded : l10n.friendsUpdated),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final friends = ref.watch(friendsProvider);
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.friendsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded),
            tooltip: l10n.friendsMyQrTitle,
            onPressed: () => _showMyQr(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // QR scan button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: FilledButton.icon(
              onPressed: () => _openScanner(context),
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: Text(l10n.friendsScanQr),
            ),
          ),
          const SizedBox(height: 12),

          // NEARBY section
          _SectionHeader(
            l10n.friendsSectionNearby,
            action: _scanning
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    onPressed: _startScan,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
          ),
          if (_nearby.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                BleService.instance.isBluetoothOn
                    ? (_scanning
                        ? l10n.friendsNearbyScanning
                        : l10n.friendsNearbyEmpty)
                    : l10n.friendsNearbyBleOff,
                style: TextStyle(
                    color: scheme.onSurfaceVariant, fontSize: 14),
              ),
            )
          else
            ..._nearby.map(
              (d) => _NearbyTile(
                device: d,
                onTap: () => _connectViaBle(d),
              ),
            ),

          const SizedBox(height: 12),

          // FRIENDS section
          _SectionHeader(l10n.friendsSectionList),
          if (friends.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(
                l10n.friendsEmpty,
                style: TextStyle(
                    color: scheme.onSurfaceVariant, fontSize: 14),
              ),
            )
          else
            ...friends.map(
              (f) => _FriendTile(
                friend: f,
                onTap: () => showFriendDetail(context, f, ref),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 16, 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: scheme.primary,
            ),
          ),
          const Spacer(),
          ?action,
        ],
      ),
    );
  }
}

// ── Nearby device tile ─────────────────────────────────────────────────────────

class _NearbyTile extends StatelessWidget {
  const _NearbyTile({required this.device, required this.onTap});

  final NearbyDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(Icons.bluetooth_rounded, color: scheme.primary),
      title: Text(device.localName,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${device.rssi} dBm'),
      trailing: TextButton(
        onPressed: onTap,
        child: Text(context.l10n.friendsNearbyConnect),
      ),
    );
  }
}

// ── Friend list tile ───────────────────────────────────────────────────────────

class _FriendTile extends StatelessWidget {
  const _FriendTile({required this.friend, required this.onTap});

  final FriendProfile friend;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rank =
        Rank.values.elementAtOrNull(friend.rankIndex) ?? Rank.beginner;
    final l10n = context.l10n;

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child:
            Icon(Icons.person_rounded, color: scheme.onPrimaryContainer),
      ),
      title: Text(friend.displayName,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        '${rank.localizedName(l10n)} · ${friend.totalSP} SP · ${friend.currentStreak} 🔥',
        style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}