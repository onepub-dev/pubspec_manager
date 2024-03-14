import 'dart:io';

import 'package:path/path.dart';
import 'package:pubspec_manager/pubspec_manager.dart';

void main() {
  create();

  updateVersion();

  replaceDependency();
}

void create() {
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

void updateVersion() {
  var pubspec = PubSpec.load();
  pubspec.version.set('1.2.1');
  pubspec.save();

  /// Or load from a specific file and save to a different file
  /// change the projects name and add a comment above the name.
  pubspec = PubSpec.loadFromPath(join('/', 'some', 'path', 'pubspec.yaml'));
  pubspec.name
    ..set('new_name')
    ..comments.append('This is the new name of the project');
  pubspec.saveTo(join('/', 'some', 'other', 'path', 'pubspec.yaml'));
}

/// Replace the money dependency with the money2 dependency.
void replaceDependency() {
  final pubspec = PubSpec.load();
  pubspec.dependencies
    ..remove('money')
    ..append(DependencyPubHostedBuilder(name: 'money2'));
  pubspec.save();
}
