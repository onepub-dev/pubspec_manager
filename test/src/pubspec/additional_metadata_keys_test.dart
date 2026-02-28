import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import '../util/read_file.dart';
import '../util/with_temp_file.dart';

void main() {
  test('load additional documented metadata keys', () {
    const content = '''
name: sample
funding:
  - https://example.com/sponsor
false_secrets:
  - /test/fixtures/not_a_secret.txt
topics:
  - tooling
ignored_advisories:
  - GHSA-4rgh-jx4f-qfcq
screenshots:
  - description: Home screen
    path: assets/home.png
''';

    final pubspec = PubSpec.loadFromString(content);
    expect(pubspec.funding.list, equals(['https://example.com/sponsor']));
    expect(
        pubspec.falseSecrets.list, equals(['/test/fixtures/not_a_secret.txt']));
    expect(pubspec.topics.list, equals(['tooling']));
    expect(pubspec.ignoredAdvisories.list, equals(['GHSA-4rgh-jx4f-qfcq']));
    expect(pubspec.screenshots.length, equals(1));
    expect(pubspec.screenshots.list.first.description, equals('Home screen'));
    expect(pubspec.screenshots.list.first.path, equals('assets/home.png'));
  });

  test('add and persist additional documented metadata keys', () async {
    final pubspec = PubSpec(name: 'sample')
      ..funding.add('https://example.com/sponsor')
      ..falseSecrets.add('/test/fixtures/not_a_secret.txt')
      ..topics.add('tooling')
      ..ignoredAdvisories.add('GHSA-4rgh-jx4f-qfcq')
      ..screenshots.add(description: 'Home screen', path: 'assets/home.png');

    await withTempFile((tempFile) async {
      pubspec.saveTo(tempFile);

      final saved = readFile(tempFile);
      expect(saved, contains('funding:'));
      expect(saved, contains('false_secrets:'));
      expect(saved, contains('topics:'));
      expect(saved, contains('ignored_advisories:'));
      expect(saved, contains('screenshots:'));

      final reloaded = PubSpec.loadFromPath(tempFile);
      expect(reloaded.funding.list, equals(['https://example.com/sponsor']));
      expect(reloaded.falseSecrets.list,
          equals(['/test/fixtures/not_a_secret.txt']));
      expect(reloaded.topics.list, equals(['tooling']));
      expect(reloaded.ignoredAdvisories.list, equals(['GHSA-4rgh-jx4f-qfcq']));
      expect(reloaded.screenshots.length, equals(1));
      expect(
          reloaded.screenshots.list.first.description, equals('Home screen'));
      expect(reloaded.screenshots.list.first.path, equals('assets/home.png'));
    });
  });
}
