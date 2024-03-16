# pubspec_manager

pubspec_manager allows you to read, modify and write pubspec.yaml files.

Why another pubspec.yaml manipulation file?

As a sometimes maintainer of the pubspec package and the creator of the fork
pubspec2, I've long been unhappy with the usability and maintainability of 
the pubspec package.

There are also a number of other pubspec maintinance packages but none of them
meet all of my criteria. In particualar none of them are able to preserve 
comments.

So the aim of pubspec_manager is to fix three problems

1) simplified API
2) fully type safe code base to ease maintenance
3) preservation of comments when modifying an existing pubspec.yaml
4) abiltity to modify every elment of a pubspec.yaml including comments.
5) retention of non pubspec specific content


# Support

The pubspec_manager package is supported by OnePub - the Dart private repository.

Register on [OnePub](https://onepub.dev) for a free two user license - no credit card required.

Pubspec Manager gives you access to all of the pubspec attributes with the ability to add, modify and delete any ellement.

You can also get access to elements outside of the pubspec specification via the underlying Document view `pubspec.document` which provides line level access.

# See also
Developers often use the [pub_semver](https://pub.dev/packages/pub_semver) package with Pubspec Manager as it will allow you to perform operations on the version such as 'next major version'.
The version object can take a String or you can call `Version.setSemVersion` or `Version.getSemVersion` to work directly with the `pub_semver` package.


# Examples
The following examples shows how to create a new pubspec.yaml from scratch.

```dart
import 'dart:io';

import 'package:path/path.dart';
import 'package:pubspec_manager/pubspec_manager.dart';


void create() {
  // create a pubspec in memory
  PubSpec(
    name: 'new eric',
    version: '1.0.0-alpha.2',
    description: 'An example',
    environment: EnvironmentBuilder(sdk: '>3.0.0 <=4.0.0', flutter: '1.0.0'),
  )
    // modify name, version, description and environment to show how it's
    // done but it makes no sense to do it here as the above ctor already
    // set them.
    ..name.set('erica')
    ..version.set('1.0.1')
    ..description.set('A change of description') // desc
    ..environment.set(sdk: '>3.0.0 <=4.0.0', flutter: '1.0.0')
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
          hostedUrl: 'https://onepub.dev',
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

    /// persist the file to disk in the current directory
    /// as pubspec.yaml
    ..save();
}

```

# update a version
Updating a pubspec version is a common task:

```dart
/// load the the pubspec.yaml from local dart project directory,
/// update the version and save it back.
///
void updateVersion() {
  final pubspec = PubSpec.load();
  pubspec.version.set('1.2.1');
  pubspec.save();
}

```

# update dependencies

```dart
/// Replace the money dependency with the money2 dependency.
void replaceDependency() {
  final pubspec = PubSpec.load();
  pubspec.dependencies
    ..remove('money')
    ..append(DependencyPubHostedBuilder(name: 'money2'));
  pubspec.save();
}
```

# load and save pubspec to a specific file.

```dart
/// Or load from a specific file and save to a different file
/// change the projects name and add a comment above the name.
void explicitPath() {
  final pubspec =
      PubSpec.loadFromPath(join('/', 'some', 'path', 'pubspec.yaml'));
  pubspec.name
    ..set('new_name')
    ..comments.append('This is the new name of the project');
  pubspec.saveTo(join('/', 'some', 'other', 'path', 'pubspec.yaml'));
}

```






