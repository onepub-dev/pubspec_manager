import 'dart:io';

import 'package:eric/eric.dart';

void main() {
  final pubspec = Pubspec(
      name: 'new eric',
      version: '1.0.0-alpha.2',
      description: 'An example',
      environment: Environment(sdk: '>3.0.0 <=4.0.0'))
    ..documentation
        .url('https://onepub.dev')
        .comments
        .append('This is the doco')
    ..dependencies
        .append(HostedDependency(name: 'dcli', url: 'https://onepub.dev'))
        .comments
        .append('DCLI to do file system stuff')
        .append('Hello world')
    ..dependencies
        .append(PubHostedDependency(name: 'dcli_core', version: '1.0.0'))
    ..save(filename: 'example.yaml');

  print(File(pubspec.loadedFrom).readAsStringSync());
}
