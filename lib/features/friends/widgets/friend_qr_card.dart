import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// The white card with a friend QR code and the app icon in its middle.
///
/// The icon is decoration. If it cannot be loaded (a dev server that went away,
/// a missing asset), Flutter would paint the error text right over the code and
/// make it unreadable, so a failed icon is simply left out. The code itself
/// uses error correction level H and survives a covered centre either way.
class FriendQrCard extends StatelessWidget {
  const FriendQrCard({super.key, required this.payload});

  final String payload;

  static const _size = 200.0;
  static const _logoSize = 42.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          QrImageView(
            data: payload,
            version: QrVersions.auto,
            size: _size,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/icon/icon.png',
              width: _logoSize,
              height: _logoSize,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
