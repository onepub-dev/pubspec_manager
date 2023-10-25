import 'dart:io';

import 'package:pubspec_manager/pubspec_manager.dart';

void main() {
  final pubspec = PubSpec(
    name: 'new eric',
    version: '1.0.0-alpha.2',
    description: 'An example',
    environment: EnvironmentBuilder(sdk: '>3.0.0 <=4.0.0'),
  )
    ..documentation
        .set('https://onepub.dev')
        .comments
        .append('This is the doco')
    ..homepage
        .set('https://onepub.dev/home')
        .comments
        .append('The home page')
        .append('more')
    ..issueTracker
        .set('https://onepub.dev/Issues')
        .comments
        .append('Log bugs here')
    ..repository
        .set('https://onepub.dev/Issues')
        .comments
        .append('The code is here')
    ..dependencies
        .append(HostedDependencyBuilder(
          name: 'dcli',
          hosted: 'https://onepub.dev',
          comments: const ['DCLI to do file system stuff', 'Hello world'],
        ))
        .append(PubHostedDependencyBuilder(name: 'dcli_core', version: '1.0.0'))
    ..devDependencies
        .append(
          PubHostedDependencyBuilder(
              comments: const ['hi there', 'ho there'],
              name: 'test',
              version: '1.0.0'),
        )
        .append(PubHostedDependencyBuilder(
          name: 'test_it',
          version: '1.0.0',
        ))
    ..save(filename: 'example.yaml');

  print(File(pubspec.loadedFrom).readAsStringSync());
}
