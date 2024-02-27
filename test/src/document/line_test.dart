import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  test('line ...', () async {
    Document.loadFromString('''
  name: hi

''');
  });
}
