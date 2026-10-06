import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/extensions/build_context_l10n.dart';

/// Shown instead of the camera preview when the QR scanner cannot start.
///
/// mobile_scanner's own error widget is a black box with an icon and no
/// explanation, which is no help to someone whose browser blocked the camera.
/// This one says what happened, how to fix it, and lets the user try again.
class ScannerErrorView extends StatelessWidget {
  const ScannerErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.isWeb = kIsWeb,
  });

  final MobileScannerException error;
  final VoidCallback onRetry;

  /// Whether the hint should talk about the browser or about system settings.
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (IconData icon, String title, String body) = switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied => (
          Icons.no_photography_outlined,
          l10n.friendsScanCameraDeniedTitle,
          isWeb
              ? l10n.friendsScanCameraDeniedWeb
              : l10n.friendsScanCameraDeniedApp,
        ),
      MobileScannerErrorCode.unsupported => (
          Icons.videocam_off_outlined,
          l10n.friendsScanCameraUnsupportedTitle,
          l10n.friendsScanCameraUnsupportedBody,
        ),
      _ => (
          Icons.error_outline,
          l10n.friendsScanCameraFailedTitle,
          l10n.friendsScanCameraFailedBody,
        ),
    };
    final detail = error.errorDetails?.message;

    return ColoredBox(
      color: Colors.black,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 56, color: Colors.white70),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.friendsScanTryAgain),
                ),
                // The browser / OS message, small: useful in a bug report.
                if (detail != null && detail.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    detail,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
