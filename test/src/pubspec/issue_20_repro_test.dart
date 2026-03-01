import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  test('issue #20 repro - flutter_lints detected after path dep + comments', () {
    const content = '''
name: sample
dev_dependencies:
  #packages
  local_package:
    path: ../../packages/local_package
    
  #pub.dev
  flutter_lints: 5.0.0
''';

    final pubspec = PubSpec.loadFromString(content);
    expect(pubspec.devDependencies.exists('local_package'), isTrue);
    expect(pubspec.devDependencies.exists('flutter_lints'), isTrue);
  });
}
