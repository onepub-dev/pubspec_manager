import 'package:pubspec_manager/src/document/document.dart';
import 'package:test/test.dart';

void main() {
  test('line ...', () async {
    Document.loadFromString('''
  name: hi

''');
  });
}
