import 'package:eric/eric.dart';

void main() {
  Pubspec(
      name: 'new eric',
      version: '1.0.0-alpha.2',
      description: 'An example',
      environment: Environment(sdk: '>3.0.0 <=4.0.0'))
    ..dependencies
        .append(HostedDependency(name: 'dcli', url: 'https://onepub.dev'))
        .comments
        .append('DCLI for do file system stuff')
        .append('Hello world')
    ..dependencies
        .append(PubHostedDependency(name: 'dcli_core', version: '1.0.0'))
    ..save(filename: 'example.yaml');
}
