import 'dart:io';

import 'package:caliday/data/static/animation_crops.dart';
import 'package:flutter_test/flutter_test.dart';

/// The thumbnails crop each animation to its figure; a new or redrawn file
/// needs `python3 tools/lottie/thumb_crops.py`.
void main() {
  final files = Directory('assets/animations')
      .listSync()
      .whereType<File>()
      .map((f) => f.path.replaceAll(r'\', '/'))
      .where((p) => p.endsWith('.json'))
      .toSet();

  test('every animation has its square, and no square is left over', () {
    expect(kAnimationCrops.keys.toSet(), files);
  });

  test('every square is centred on the 400 x 400 canvas and not a sliver of it',
      () {
    for (final MapEntry(key: path, value: (left, top, side))
        in kAnimationCrops.entries) {
      expect(side, inInclusiveRange(150, 500), reason: path);
      expect(left + side / 2, inInclusiveRange(0, 400), reason: path);
      expect(top + side / 2, inInclusiveRange(0, 400), reason: path);
    }
  });
}
