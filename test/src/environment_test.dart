import 'dart:io';

import 'package:eric/eric.dart';
import 'package:path/path.dart' hide equals;
import 'package:test/test.dart';

void main() {
  group('environment', () {
    test('set', () {
      final pathTo =
          join(Directory.systemTemp.path, 'pubspec_environment.yaml');
      final pubspec = Pubspec(
          name: 'test',
          description: 'test desc',
          environment: Environment(sdk: '1.0.0'),
          version: '1.0.0');

      expect(pubspec.environment.sdk, equals('1.0.0'));
      expect(pubspec.environment.flutter, equals(''));

      pubspec.environment.flutter = '1.2.4';
      pubspec.environment.sdk = '1.2.1';

      pubspec.saveTo(pathTo);

      final updated = Pubspec.loadFile(pathTo);
      expect(updated.environment.flutter, equals('1.2.4'));
      expect(updated.environment.sdk, equals('1.2.1'));
    });
  });
}
