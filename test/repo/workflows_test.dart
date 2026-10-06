import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The jobs of a workflow file by name: the 2-space-indented keys under
/// `jobs:`, each with the text up to the next job.
Map<String, String> jobsOf(String yaml) {
  final block = yaml.substring(yaml.indexOf('\njobs:'));
  final names = RegExp(r'^  ([a-z][a-z0-9_-]*):\s*$', multiLine: true)
      .allMatches(block)
      .map((m) => m.group(1)!)
      .toList();
  return {
    for (var i = 0; i < names.length; i++)
      names[i]: block.substring(
        block.indexOf('\n  ${names[i]}:'),
        i + 1 < names.length ? block.indexOf('\n  ${names[i + 1]}:') : block.length,
      ),
  };
}

/// The workflows cannot be run from here, but the mistakes that cost the most
/// are plain text drift, and those can be checked.
void main() {
  final workflows = {
    for (final name in ['web.yml', 'ci.yml', 'release.yml'])
      name: File('.github/workflows/$name').readAsStringSync(),
  };

  test('every workflow pins the same Flutter version', () {
    final versions = <String, String>{};
    for (final entry in workflows.entries) {
      final match = RegExp(r'(?:FLUTTER_VERSION|flutter-version):\s*([0-9][0-9.]*)')
          .firstMatch(entry.value);
      expect(match, isNotNull, reason: '${entry.key} pins no Flutter version');
      versions[entry.key] = match!.group(1)!;
    }
    // pubspec.lock is resolved against the SDK-pinned packages of one version.
    expect(versions.values.toSet(), hasLength(1), reason: '$versions');
  });

  group('release.yml stays disabled until it is switched on', () {
    final release = workflows['release.yml']!;
    final jobs = jobsOf(release);
    final jobNames = jobs.keys.toList();
    String jobBody(String name) => jobs[name]!;

    test('has the expected jobs', () {
      expect(jobNames, ['verify', 'android', 'ios', 'release']);
    });

    test('the first job needs the RELEASE_BUILDS_ENABLED switch', () {
      expect(jobBody('verify'),
          contains("vars.RELEASE_BUILDS_ENABLED == 'true'"));
    });

    test('every other job depends on another job, so it is skipped with it', () {
      for (final name in jobNames.where((n) => n != 'verify')) {
        expect(jobBody(name), contains('needs:'), reason: name);
      }
    });

    test('it runs on tags and by hand only, never on a branch push', () {
      expect(release, contains("tags: ['v*']"));
      expect(release, contains('workflow_dispatch:'));
      expect(release, isNot(contains('branches:')));
    });
  });

  group('the web deploy waits for the tests', () {
    final jobs = jobsOf(workflows['web.yml']!);

    test('there is a job that runs flutter test', () {
      expect(jobs, contains('test'));
      expect(jobs['test'], contains('flutter test'));
    });

    test('deploy needs both the build and the tests', () {
      final deploy = jobs['deploy']!;
      final needs = RegExp(r'needs:\s*\[([^\]]*)\]').firstMatch(deploy);
      expect(needs, isNotNull, reason: 'deploy has no `needs: [..]` list');
      expect(needs!.group(1)!.split(',').map((s) => s.trim()).toSet(),
          {'build', 'test'});
    });
  });

  test('ci.yml checks the generated l10n files and builds Android', () {
    final ci = workflows['ci.yml']!;
    expect(ci, contains('git diff --exit-code -- lib/l10n'));
    expect(ci, contains('flutter build apk'));
    expect(ci, contains('flutter analyze'));
    expect(ci, contains('flutter test'));
  });
}
