import 'package:eric/eric.dart';

void main() {
  Pubspec.fromFile()
    ..name.value = 'new eric'
    ..version.value = '1.0.0-alpha.2'
    ..dependencies
        .append(HostedDependency(name: 'dcli', url: 'https://onepub.dev'))
    ..dependencies.append(PubHostedDependency(name: 'dcli', version: '1.0.0'))
    ..save();
}
