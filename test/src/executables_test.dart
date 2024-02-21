import 'package:path/path.dart' hide equals;
import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

const _testPubspec = '''
name: test
version: 1.0.0
description: testing testing.
environment:
  sdk: 3.0.0
executables:
  dcli:
  dcli_sdk:
   ''';

void main() {
  group('executables ...', () {
    test('update', () {
      final pubspec = PubSpec.loadFromString(_testPubspec);
      pubspec.executables.append(ExecutableBuilder(name: 'full'));
      expect(pubspec.executables['full'], isNotNull);
      expect(pubspec.executables['full']!.sectionHeading.text, '  full:');

      expect(pubspec.executables['dcli']!.scriptPath,
          equals(join('bin', 'dcli.dart')));
      pubspec.executables['dcli']!.script = 'dcli_tool';
      expect(pubspec.executables['dcli']!.script, equals('dcli_tool'));
      expect(pubspec.executables['dcli']!.scriptPath,
          equals(join('bin', 'dcli_tool.dart')));

      pubspec.executables['dcli']!.name = 'dcli1';
      expect(pubspec.executables['dcli'], isNull);
      expect(pubspec.executables['dcli1']!.name, equals('dcli1'));

      print(pubspec);
    });

    test('iterate', () {
      final pubspec = PubSpec.loadFromString(_testPubspec);

      final found = <String>{};
      for (final executable in pubspec.executables) {
        found.add(executable.name);
      }
      expect(found.length, equals(2));
      expect(found.contains('dcli'), isTrue);
      expect(found.contains('dcli_sdk'), isTrue);
    });
  });
}
