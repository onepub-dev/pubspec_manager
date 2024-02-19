import 'dart:io';

import 'package:path/path.dart' hide equals;
import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  group('environment', () {
    ////////////////////////////////////////////////////////////
    test('set', () {
      final pathTo =
          join(Directory.systemTemp.path, 'pubspec_environment.yaml');
      final pubspec = PubSpec(
          name: 'test',
          description: 'test desc',
          environment: EnvironmentBuilder(sdk: '1.0.0'),
          version: '1.0.0');

      expect(pubspec.environment.sdk, equals('1.0.0'));
      expect(pubspec.environment.flutter, equals(''));

      pubspec.environment.flutter = '1.2.4';
      pubspec.environment.sdk = '1.2.1';

      pubspec.saveTo(pathTo);

      final updated = PubSpec.loadFromPath(pathTo);
      expect(updated.environment.flutter, equals('1.2.4'));
      expect(updated.environment.sdk, equals('1.2.1'));
    });

    //////////////////////////////////////////////////////////////
    test('sdk range from ctor', () {
      final pubspec = PubSpec(
          name: 'test',
          description: 'test desc',
          environment: EnvironmentBuilder(sdk: '>=3.0.0 <4.0.0'),
          version: '1.0.0');

      final environment = pubspec.environment;
      expect(environment.sdk, equals('>=3.0.0 <4.0.0'));
    });

    ////////////////////////////////////////////////////////////
    test('sdk range from string - quoted', () {
      final pubspec = PubSpec.loadFromString('''
name: test
version: 1.0.0
description: testing testing.
environment:
  sdk: '>=3.0.0 <4.0.0'
executables:
  dcli:
   ''');

      final environment = pubspec.environment;
      // check we retained the quotes
      expect(environment.sdk, equals("'>=3.0.0 <4.0.0'"));
    });

    ////////////////////////////////////////////////////////////
    test('sdk range from string - unquoted', () {
      final pubspec = PubSpec.loadFromString('''
name: test
version: 1.0.0
description: testing testing.
environment:
  sdk: 1.0.0
executables:
  dcli:
   ''');

      final environment = pubspec.environment;
      // check we retained the quotes
      expect(environment.sdk, equals('1.0.0'));
    });

    ////////////////////////////////////////////////////////////
    test('assign sdk', () {
      final pubspec = PubSpec.loadFromString('''
name: test
version: 1.0.0
description: testing testing.
environment:
  sdk: 1.0.0
executables:
  dcli:
   ''');

      final environment = pubspec.environment;
      // check we retained the quotes
      expect(environment.sdk, equals('1.0.0'));
      environment.sdk = '2.0.0';
      expect(environment.sdk, equals('2.0.0'));

      environment.sdk = "'>=3.0.0 < 4.0.0'";
      expect(environment.sdk, equals("'>=3.0.0 <4.0.0'"));

      // empty sdk
      environment.sdk = '';
      expect(environment.sdk, equals(''));

      // any sdk
      environment.sdk = 'any';
      expect(environment.sdk, equals('any'));
    });
  });
}
