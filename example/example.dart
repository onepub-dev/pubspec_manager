import 'package:eric/eric.dart';

void main() {
  PubSpec.fromFile()
    ..name.value = 'new eric'
    ..version.value = '1.0.0-alpha.2'
    ..dependencies.append(HostedDependencyImpl('dcli'));
    ..save();
}
