import 'dart:io';

import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

import '../util/with_temp_file.dart';

void main() {
  test('description ...', () async {
    final pubspec = PubSpec(name: 'test');
    pubspec.description.set('This is a pubspec');

    await withTempFile((tempFile) async {
      pubspec.saveTo(tempFile);
      final lines = File(tempFile).readAsLinesSync();
      expect(lines.length, equals(2));
      expect(lines[0], equals('name: test'));
      expect(lines[1], equals('description: This is a pubspec'));
    });
  });
}
