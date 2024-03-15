import 'package:path/path.dart';
import 'package:pubspec_manager/pubspec_manager.dart';

void main() {
  create();

  updateVersion();

  replaceDependency();

  explicitPath();
}

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

    /// persist the file to disk in the current directory
    /// as pubspec.yaml
    ..save();
}

/// load the the pubspec.yaml from local dart project directory,
/// update the version and save it back.
///
void updateVersion() {
  final pubspec = PubSpec.load();
  pubspec.version.set('1.2.1');
  pubspec.save();
}

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

/// Replace the money dependency with the money2 dependency.
void replaceDependency() {
  final pubspec = PubSpec.load();
  pubspec.dependencies
    ..remove('money')
    ..append(DependencyPubHostedBuilder(name: 'money2'));
  pubspec.save();
}
