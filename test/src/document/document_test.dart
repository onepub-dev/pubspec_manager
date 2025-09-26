import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  group('document', () {
    test('empty', () {
      final doc = Document.loadFromString('''
''');
      expect(doc.lines.length, equals(0));
    });

    test('one blank line', () {
      final doc = Document.loadFromString('''

''');
      expect(doc.lines.length, equals(1));
    });

    test('simple', () {
      final doc = Document.loadFromString('''
name: my_package

''');
      expect(doc.lines.length, equals(2));
      expect(doc.lines[0].text, equals('name: my_package'));
      expect(doc.lines[1].text, equals(''));
    });
  });
}
