
import 'package:caliday/features/friends/widgets/friend_qr_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// An asset bundle that cannot load anything, like a page whose dev server went
/// away: "Unable to load asset: AssetManifest.bin.json".
class _BrokenBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) =>
      Future<ByteData>.error(FlutterError('Unable to load asset: "$key".'));
}

Widget _app({AssetBundle? bundle}) {
  final card = const Center(child: FriendQrCard(payload: 'caliday://friend?data=abc'));
  return MaterialApp(
    home: Scaffold(
      body: bundle == null
          ? card
          : DefaultAssetBundle(bundle: bundle, child: card),
    ),
  );
}

void main() {
  testWidgets('shows the QR code', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();
    expect(find.byType(QrImageView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a logo that cannot be loaded does not draw an error over the code',
      (tester) async {
    await tester.pumpWidget(_app(bundle: _BrokenBundle()));
    await tester.pump();
    await tester.pump();

    // The QR is there, and nothing was reported or painted for the logo.
    expect(find.byType(QrImageView), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Unable to load asset'), findsNothing);
  });
}
