import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import '../util/with_temp_file.dart';


const content = '''
name: one
description: fred
environment:
  sdk: 1.2.3
dependencies:
  money: ^1.0.0
''';
void main() {
  test('replace dependency ...', () async {
    await withTempFile<void>((pubspecFile) async {
      var pubspec = PubSpec.loadFromString(content);

      expect(pubspec.dependencies.exists('money'), isTrue);

      pubspec.dependencies
        ..remove('money')
        ..append(DependencyPubHostedBuilder(name: 'money2'));
      expect(pubspec.dependencies.exists('money'), isFalse);
      expect(pubspec.dependencies.exists('money2'), isTrue);
      pubspec.saveTo(pubspecFile);

      // reload from disk to ensure the expect values.
      pubspec = PubSpec.loadFromPath(pubspecFile);
      expect(pubspec.dependencies.exists('money'), isFalse);
      expect(pubspec.dependencies.exists('money2'), isTrue);
    });
  });
}
