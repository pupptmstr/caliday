import 'package:caliday/features/friends/widgets/scanner_error_view.dart';
import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<void> _pump(
  WidgetTester tester, {
  required MobileScannerErrorCode code,
  String? message,
  bool isWeb = false,
  String locale = 'en',
  VoidCallback? onRetry,
}) {
  return tester.pumpWidget(MaterialApp(
    locale: Locale(locale),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: ScannerErrorView(
        isWeb: isWeb,
        onRetry: onRetry ?? () {},
        error: MobileScannerException(
          errorCode: code,
          errorDetails: message == null
              ? null
              : MobileScannerErrorDetails(message: message),
        ),
      ),
    ),
  ));
}

void main() {
  testWidgets('permission denied in a browser says how to unblock the camera',
      (tester) async {
    await _pump(tester,
        code: MobileScannerErrorCode.permissionDenied,
        message: 'Camera permission denied, NotAllowedError: Permission denied',
        isWeb: true);

    expect(find.text('Camera access is blocked'), findsOneWidget);
    expect(find.textContaining('address bar'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    // The raw browser message is kept, small, for bug reports.
    expect(find.textContaining('NotAllowedError'), findsOneWidget);
  });

  testWidgets('permission denied in the app points at the system settings',
      (tester) async {
    await _pump(tester, code: MobileScannerErrorCode.permissionDenied);
    expect(find.textContaining('device settings'), findsOneWidget);
    expect(find.textContaining('address bar'), findsNothing);
  });

  testWidgets('no camera suggests showing your own QR instead', (tester) async {
    await _pump(tester, code: MobileScannerErrorCode.unsupported);
    expect(find.text('No camera available'), findsOneWidget);
    expect(find.textContaining('own QR code'), findsOneWidget);
  });

  testWidgets('any other failure gets a generic message', (tester) async {
    await _pump(tester, code: MobileScannerErrorCode.genericError);
    expect(find.text('Could not start the camera'), findsOneWidget);
  });

  testWidgets('the button calls onRetry', (tester) async {
    var retries = 0;
    await _pump(tester,
        code: MobileScannerErrorCode.permissionDenied,
        onRetry: () => retries++);
    await tester.tap(find.text('Try again'));
    expect(retries, 1);
  });

  testWidgets('Russian', (tester) async {
    await _pump(tester,
        code: MobileScannerErrorCode.permissionDenied,
        locale: 'ru',
        isWeb: true);
    expect(find.text('Доступ к камере заблокирован'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);
  });

  testWidgets('every error code renders a message and a retry button',
      (tester) async {
    for (final code in MobileScannerErrorCode.values) {
      await _pump(tester, code: code);
      expect(find.text('Try again'), findsOneWidget, reason: code.name);
    }
  });
}
