import 'package:pubspec_manager/src/document/document.dart';
import 'package:test/test.dart';

void main() {
  group('document', () {
    test('empty', () async {
      final doc = Document.loadFromString('''
''');
      expect(doc.lines.length, equals(0));
    });

    test('one blank line', () async {
      final doc = Document.loadFromString('''

''');
      expect(doc.lines.length, equals(1));
    });

    test('simple', () async {
      final doc = Document.loadFromString('''
name: my_package

''');
      expect(doc.lines.length, equals(2));
      expect(doc.lines[0].text, equals('name: my_package'));
      expect(doc.lines[1].text, equals(''));
    });
  });
}
