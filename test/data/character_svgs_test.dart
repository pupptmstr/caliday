import 'dart:io';

import 'package:caliday/data/models/enums.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

/// The character art (Goro, Skala, the course hosts) is hand-written or
/// generated SVG. flutter_svg drops what it cannot parse without a word, so
/// every file is decoded here the way the app draws it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final files = [
    for (final dir in ['assets/goro', 'assets/skala', 'assets/hosts'])
      ...Directory(dir).listSync().whereType<File>().where((f) => f.path.endsWith('.svg')),
  ]..sort((a, b) => a.path.compareTo(b.path));

  test('there are character files to check', () {
    expect(files.length, greaterThanOrEqualTo(14));
  });

  test('every course has a host portrait and a cheering pose on disk', () {
    for (final course in CourseId.values) {
      expect(File(course.hostPortrait).existsSync(), isTrue, reason: course.name);
      expect(File(course.hostCheer).existsSync(), isTrue, reason: course.name);
    }
  });

  for (final file in files) {
    test('${file.path} decodes', () async {
      final info = await vg.loadPicture(SvgStringLoader(file.readAsStringSync()), null);
      expect(info.size.width, 1024, reason: 'the art is drawn on a 1024 canvas');
      expect(info.size.height, 1024);
      info.picture.dispose();
    });
  }
}
