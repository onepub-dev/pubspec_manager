import 'package:eric/src/pubspec.dart';
import 'package:test/test.dart';

const simple =
    '''
name: eric
version: 0.0.1
description: A simple command-line application created by dcli
environment: 
  sdk: '>=2.19.0 <3.0.0'
''';

const plainScalerDesc =
    '''
A simple command-line application created by dcli
  second line
  third lien''';

const plainScaler =
    '''
name: eric
version: 0.0.1
description: $plainScalerDesc
environment: 
  sdk: '>=2.19.0 <3.0.0'
dependencies:
  dcli:
''';

const foldedBlockSclaer =
    '''
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
      final pubspec = PubSpec.fromString(simple);

      expect(pubspec.description.value,
          equals('A simple command-line application created by dcli'));
    });

    test('plainScalar', () {
      final pubspec = PubSpec.fromString(simple);

      expect(pubspec.description.value, equals(plainScalerDesc));
    });
  });
}
