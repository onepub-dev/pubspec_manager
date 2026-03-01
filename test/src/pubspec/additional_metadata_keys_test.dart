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

  test('exists semantics for new list keys', () {
    final pubspec = PubSpec(name: 'sample')
      ..funding.add('https://example.com/sponsor')
      ..falseSecrets.add('/test/fixtures/not_a_secret.txt')
      ..topics.add('tooling')
      ..ignoredAdvisories.add('GHSA-4rgh-jx4f-qfcq');

    expect(pubspec.funding.exists('https://example.com/sponsor'), isTrue);
    expect(pubspec.funding.exists('https://example.com/other'), isFalse);

    expect(pubspec.falseSecrets.exists('/test/fixtures/not_a_secret.txt'),
        isTrue);
    expect(pubspec.falseSecrets.exists('/tmp/other.txt'), isFalse);

    expect(pubspec.topics.exists('tooling'), isTrue);
    expect(pubspec.topics.exists('backend'), isFalse);

    expect(pubspec.ignoredAdvisories.exists('GHSA-4rgh-jx4f-qfcq'), isTrue);
    expect(pubspec.ignoredAdvisories.exists('GHSA-missing-id'), isFalse);
  });

  test('new keys with no values load and round-trip', () async {
    const content = '''
name: sample
funding:
false_secrets:
topics:
ignored_advisories:
screenshots:
''';

    final pubspec = PubSpec.loadFromString(content);
    expect(pubspec.funding.missing, isFalse);
    expect(pubspec.falseSecrets.missing, isFalse);
    expect(pubspec.topics.missing, isFalse);
    expect(pubspec.ignoredAdvisories.missing, isFalse);
    expect(pubspec.screenshots.missing, isFalse);

    expect(pubspec.funding.list, isEmpty);
    expect(pubspec.falseSecrets.list, isEmpty);
    expect(pubspec.topics.list, isEmpty);
    expect(pubspec.ignoredAdvisories.list, isEmpty);
    expect(pubspec.screenshots.list, isEmpty);

    await withTempFile((tempFile) async {
      pubspec.saveTo(tempFile);
      expect(readFile(tempFile), equals(content));
    });
  });

  test('new keys allow empty list item values', () async {
    const content = '''
name: sample
funding:
  -
screenshots:
  - description:
    path:
''';

    final pubspec = PubSpec.loadFromString(content);
    expect(pubspec.funding.list, equals(['']));
    expect(pubspec.screenshots.length, equals(1));
    expect(pubspec.screenshots.list.first.description, equals(''));
    expect(pubspec.screenshots.list.first.path, equals(''));

    final generated = PubSpec(name: 'sample')
      ..funding.add('')
      ..screenshots.add(description: '', path: '');

    await withTempFile((tempFile) async {
      generated.saveTo(tempFile);
      const generatedContent = '''
name: sample
funding:
  -
screenshots:
  - description: 
    path:
''';
      expect(readFile(tempFile), equals(generatedContent));
    });
  });

  test('existing single-line key with no value is preserved', () async {
    const content = '''
name: sample
homepage:
''';

    final pubspec = PubSpec.loadFromString(content);
    expect(pubspec.homepage.value, isEmpty);
    expect(pubspec.homepage.missing, isFalse);

    await withTempFile((tempFile) async {
      pubspec.saveTo(tempFile);
      expect(readFile(tempFile), equals(content));
    });
  });

  test('removing screenshot removes descendant lines', () async {
    const content = '''
name: sample
screenshots:
  - description: Home screen
    path: assets/home.png
    # screenshot comment
    extra: custom
''';

    final pubspec = PubSpec.loadFromString(content);
    expect(pubspec.screenshots.length, equals(1));

    pubspec.screenshots.removeAt(0);
    expect(pubspec.screenshots.list, isEmpty);

    await withTempFile((tempFile) async {
      pubspec.saveTo(tempFile);
      const expected = '''
name: sample
screenshots:
''';
      expect(readFile(tempFile), equals(expected));
    });
  });

  test('removing list entry removes descendant lines for list keys', () async {
    const content = '''
name: sample
funding:
  - https://example.com/sponsor
    # funding comment
    extra: custom
''';

    final pubspec = PubSpec.loadFromString(content);
    expect(pubspec.funding.length, equals(1));

    pubspec.funding.removeAt(0);
    expect(pubspec.funding.list, isEmpty);

    await withTempFile((tempFile) async {
      pubspec.saveTo(tempFile);
      const expected = '''
name: sample
funding:
''';
      expect(readFile(tempFile), equals(expected));
    });
  });
}
