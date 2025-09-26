import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  test('line ...', () {
    Document.loadFromString('''
  name: hi

''');
  });
}
