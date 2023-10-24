import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  group('pubspec', () {
    test('update single line attributes', () async {
      final pubspec = PubSpec.fromString('''
name: test
version: 1.1.1
description: test
environment: 
  sdk: 1.1.1
''');

      pubspec.name.value = 'test2';
      expect(pubspec.name.value, equals('test2'));
      expect(pubspec.document.lines[0].text, equals('name: test2'));
    });
  });
}
