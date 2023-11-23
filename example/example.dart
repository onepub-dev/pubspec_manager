import 'dart:io';

import 'package:pubspec_manager/pubspec_manager.dart';

void main() {
  final pubspec = PubSpec(
    name: 'new eric',
    version: '1.0.0-alpha.2',
    description: 'An example',
    environment: EnvironmentBuilder(sdk: '>3.0.0 <=4.0.0', flutter: '1.0.0'),
  )
    ..homepage
        .set('https://onepub.dev/home')
        .comments
        .append('The home page')
        .append('more')
    ..repository
        .set('https://onepub.dev/Issues')
        .comments
        .append('The code is here')
    ..issueTracker
        .set('https://onepub.dev/Issues')
        .comments
        .append('Log bugs here')
    ..documentation
        .set('https://onepub.dev')
        .comments
        .append('This is the doco')
    ..dependencies
        .append(DependencyAltHostedBuilder(
          name: 'dcli',
          hosted: 'https://onepub.dev',
          comments: const ['DCLI to do file system stuff', 'Hello world'],
        ))
        .append(DependencyPubHostedBuilder(name: 'dcli_core', version: '1.0.0'))
    ..devDependencies
        .append(
          DependencyPubHostedBuilder(
              comments: const ['hi there', 'ho there'],
              name: 'test',
              version: '1.0.0'),
        )
        .append(DependencyPubHostedBuilder(
          name: 'test_it',
          version: '1.0.0',
        ))
    ..dependencyOverrides.append(DependencyPathBuilder(
      name: 'dcli',
      path: '../up/dcli',
      comments: const ['Override dcli with a local version'],
    ))
    // ..environment.
    ..save(filename: 'example.yaml');

  print(File(pubspec.loadedFrom).readAsStringSync());
}
