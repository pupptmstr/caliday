import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../data/models/friend_profile.dart';
import '../widgets/scanner_error_view.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: [BarcodeFormat.qrCode],
  );
  bool _processing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    final friend = FriendProfile.tryParseQrPayload(raw);
    if (friend == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.friendsScanError)),
        );
      }
      return;
    }

    setState(() => _processing = true);
    await _controller.stop();
    if (!mounted) return;

    final confirmed = await _showConfirmation(friend);
    if (confirmed == true && mounted) {
      Navigator.of(context).pop(friend);
    } else {
      if (mounted) setState(() => _processing = false);
      await _controller.start();
    }
  }

  /// Restarts the camera after an error (e.g. once the user has allowed it).
  /// A failure is shown by the error view, so it is not rethrown here.
  Future<void> _retry() async {
    try {
      // On the web start() creates its barcode reader before asking for the
      // camera and keeps it when that fails, so a plain second start() answers
      // "already running". Reset the platform first (mobile_scanner 7.2.0).
      if (kIsWeb) await MobileScannerPlatform.instance.stop();
      await _controller.start();
    } on MobileScannerException {
      // Surfaced through MobileScanner.errorBuilder.
    }
  }

  Future<bool?> _showConfirmation(FriendProfile friend) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(friend.displayName),
        content: Text(
          l10n.friendsScanConfirmBody(friend.totalSP, friend.currentStreak),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.friendsCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.friendsAdd),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.friendsScanQr)),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) =>
                ScannerErrorView(error: error, onRetry: _retry),
            // Only drawn while the camera preview is visible.
            overlayBuilder: (context, constraints) => Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (_processing)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}