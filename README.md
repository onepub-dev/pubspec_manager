# pubspec_manager

pubspec_manager allows you to read, .modify and write pubspec.yaml files.

Why another pubspec.yaml manipulation file?

As a sometimes maintainer of the pubspec package and the creator of the fork
pubspec2, I've long been unhappy with the usability and maintainability of 
the pubspec package.

There are also a number of other pubspec maintinance packages but none of them
meet all of the criteria. In particualar none of them are able to preserve 
comments.

So the aim of pubspec_manager is to fix three problems

1) simplified API
2) fully type safe code base to ease maintenance
3) preservation of comments when modifying an existing pubspec.yaml
4) abiltity to modify every elment of a pubspec.yaml including comments.
5) retention of non pubspec specific content


```dart
import 'dart:io';
import 'package:pubspec_manager/pubspec_manager.dart';

void main() {
  final pubspec = PubSpec(
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
```
