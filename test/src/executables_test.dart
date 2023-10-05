import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  group('executables ...', () {
    test('update', () {
      final pubspec = PubSpec.fromString('''
name: test
version: 1.0.0
description: testing testing.
environment:
  sdk: 3.0.0
executables:
  dcli:
   ''');
      pubspec.executables.append(Executable(name: 'full'));
      expect(pubspec.executables['full'], isNotNull);
      expect(pubspec.executables['full']!.line.text, '  full:');

      expect(pubspec.executables['dcli']!.scriptPath, equals('bin/dcli.dart'));
      pubspec.executables['dcli']!.script = 'dcli_tool';
      expect(pubspec.executables['dcli']!.script, equals('dcli_tool'));
      expect(pubspec.executables['dcli']!.scriptPath,
          equals('bin/dcli_tool.dart'));

      pubspec.executables['dcli']!.name = 'dcli1';
      expect(pubspec.executables['dcli'], isNull);
      expect(pubspec.executables['dcli1']!.name, equals('dcli1'));

      print(pubspec);
    });
  });
}
