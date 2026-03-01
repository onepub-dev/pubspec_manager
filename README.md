# pubspec_manager

pubspec_manager (PBM) allows you to read, modify and write pubspec.yaml files.

PBM supports the full set of documented pubspec keys and provides
an easy to use API to manger your puspec.yaml.

A core feature that sets PBM aside from other pubspec packages is that
PBM will retain any comments within the pubspec.yaml as well as
allow you to add additional comments via the api. 

PMB also gives you access to elements outside of the pubspec specification 
via the underlying Document view `PubSpec.load().document` which provides 
line level access.


So the aim of pubspec_manager is:

1) simplified API
2) fully type safe code base to ease maintenance
3) support for all documented keys
4) preservation of comments when modifying an existing pubspec.yaml
5) abiltity to modify every elment of a pubspec.yaml including comments.
6) retention and read/write access to non pubspec specific content


# Support
Maintained by the OnePub team.

OnePub is a private Dart package repository for hosting and sharing internal packages.

For questions or issues:
- Open an issue on GitHub
- Check the package docs and examples in this repository

OnePub: [https://onepub.dev](https://onepub.dev)


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
        .add(DependencyAltHostedBuilder(
          name: 'dcli',
          hostedUrl: 'https://onepub.dev',
          comments: const ['DCLI to do file system stuff', 'Hello world'],
        ))
        .add(DependencyPubHostedBuilder(name: 'dcli_core', version: '1.0.0'))
    ..devDependencies
        .add(
          DependencyPubHostedBuilder(
              comments: const ['hi there', 'ho there'],
              name: 'test',
              version: '1.0.0'),
        )
        .add(DependencyPubHostedBuilder(
          name: 'test_it',
          version: '1.0.0',
        ))
    ..dependencyOverrides.add(DependencyPathBuilder(
      name: 'dcli',
      path: '../up/dcli',
      comments: const ['Override dcli with a local version'],
    ))

    /// persist the file to disk in the current directory
    /// as pubspec.yaml
    ..save();
}

```

## Switch on a dependency type

Use pattern matching to process dependencies. 
In this example we write the dependencies out to a json file.

```dart
 switch (dependency) {
        case DependencyPubHosted(:final name, :final versionConstraint):
          final vc = versionConstraint;
          restore
            ..writeln('  $name:')
            ..writeln('    source: hosted')
            ..writeln('    constraint: "$vc"');

        case DependencyAltHosted(:final name, :final versionConstraint, :final hostedUrl):
          final vc = versionConstraint;
          restore
            ..writeln('  $name:')
            ..writeln('    source: hosted')
            ..writeln('    url: "$hostedUrl"')
            ..writeln('    constraint: "$vc"');

        case DependencyGit(:final name, :final url, :final ref, :final path):
          restore
            ..writeln('  $name:')
            ..writeln('    source: git')
            ..writeln('    url: "$url"');
          if (ref != null) {
            restore.writeln('    ref: "$ref"');
          }
          if (path != null) {
            restore.writeln('    path: "$path"');
          }

        case DependencyPath(:final name, :final path):
          restore
            ..writeln('  $name:')
            ..writeln('    source: path')
            ..writeln('    path: "$path"');

        case DependencySdk(:final name, :final sdk):
          restore
            ..writeln('  $name:')
            ..writeln('    source: sdk')
            ..writeln('    sdk: "$sdk"');
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
/// Or load from the pubspec.yaml from a specific file 
/// and save to a different file.
/// Change the projects name and add a comment above the name.
void explicitPath() {
  final pubspec =
      PubSpec.loadFromPath(join('/', 'some', 'path', 'pubspec.yaml'));
  pubspec.name
    ..set('new_name')
    ..comments.append('This is the new name of the project');
  pubspec.saveTo(join('/', 'some', 'other', 'path', 'pubspec.yaml'));
}

```



