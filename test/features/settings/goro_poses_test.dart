import 'dart:math';

import 'package:caliday/features/settings/widgets/goro_poses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

String _shown(WidgetTester tester) {
  final picture = tester.widget<SvgPicture>(find.byType(SvgPicture).last);
  return (picture.bytesLoader as SvgAssetLoader).assetName;
}

void main() {
  testWidgets('a tap shows the next pose; every pose comes up before a repeat',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Center(child: GoroPoses(random: Random(7))),
    ));
    final seen = <String>[_shown(tester)];
    for (var i = 1; i < kGoroPoses.length; i++) {
      await tester.tap(find.byType(GoroPoses));
      await tester.pumpAndSettle();
      seen.add(_shown(tester));
    }
    expect(seen.toSet(), kGoroPoses.toSet());

    await tester.tap(find.byType(GoroPoses));
    await tester.pumpAndSettle();
    expect(_shown(tester), seen.first, reason: 'then the same order again');
  });
}
