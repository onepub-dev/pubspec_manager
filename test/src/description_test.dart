import 'package:eric/eric.dart';
import 'package:test/test.dart';

const simple = '''
name: eric
version: 0.0.1
description: A simple command-line application created by dcli
environment: 
  sdk: '>=2.19.0 <3.0.0'
''';

const simpleExpected = 'A simple command-line application created by dcli';

const flowPlainScalarDescInput = '''
A simple command-line application created by dcli
  second line
  third lien''';

const flowPlainScalarDescExpected = '''
A simple command-line application created by dcli second line third lien''';

const plainScalar = '''
name: eric
version: 0.0.1
description: $flowPlainScalarDescInput
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies:
  dcli:
''';

const foldedBlockScalar = '''
name: eric
version: 0.0.1
description: >-
  A simple command-line application created by dcli
  Second line
  Third line
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies:
  dcli:
''';

void main() {
  group('description', () {
    test('simple ...', () async {
      final pubspec = Pubspec.fromString(simple);

      expect(pubspec.description.value,
          equals('A simple command-line application created by dcli'));
    });

    test('plainScalar', () {
      final pubspec = Pubspec.fromString(simple);

      expect(pubspec.description.value, equals(simpleExpected));
    });
  });
}
