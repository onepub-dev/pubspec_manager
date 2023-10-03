import 'dart:io';

import 'package:eric/eric.dart';

void main() {
  final pubspec = Pubspec(
    name: 'new eric',
    version: '1.0.0-alpha.2',
    description: 'An example',
    environment: Environment(sdk: '>3.0.0 <=4.0.0'),
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
        .append(HostedDependency(
          name: 'dcli',
          hosted: 'https://onepub.dev',
          comments: const ['DCLI to do file system stuff', 'Hello world'],
        ))
        .append(PubHostedDependency(name: 'dcli_core', version: '1.0.0'))
    ..devDependencies
        .append(
          PubHostedDependency(
              comments: const ['hi there', 'ho there'],
              name: 'test',
              version: '1.0.0'),
        )
        .append(PubHostedDependency(
          name: 'test_it',
          version: '1.0.0',
        ))
    ..save(filename: 'example.yaml');

  print(File(pubspec.loadedFrom).readAsStringSync());
}
