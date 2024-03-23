import 'package:pubspec_manager/pubspec_manager.dart';
import 'package:test/test.dart';

void main() {
  test('pub spec ...', () async {
    PubSpec(
      name: 'new eric',
    )
      ..version.set('1.0.0-alpha.2')
      ..description.set('An example')
      ..environment
          .set(sdk: '>3.0.0 <=4.0.0', flutter: '1.0.0')
          .comments
          .append('Its a flutter app')
      ..homepage
          .set('https://onepub.dev/home')
          .comments
          .append('The home page')
          .append('more')
      ..publishTo
          .set('https://onepub.dev/xxxxyyy')
          .comments
          .append('Publish to a private repo.')
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
          .add(DependencyBuilderAltHosted(
            name: 'dcli',
            hostedUrl: 'https://onepub.dev',
            comments: const ['DCLI to do file system stuff', 'Hello world'],
          ))
          .add(DependencyBuilderPubHosted(
              name: 'dcli_core', versionConstraint: '1.0.0'))
      ..devDependencies
          .add(
            DependencyBuilderPubHosted(
                comments: const ['hi there', 'ho there'],
                name: 'test',
                versionConstraint: '1.0.0'),
          )
          .add(DependencyBuilderPubHosted(
            name: 'test_it',
            versionConstraint: '1.0.0',
          ))
      ..dependencyOverrides.add(DependencyBuilderPath(
        name: 'dcli',
        path: '../../some/path',
        comments: const ['For local dev'],
      ))
      ..platforms
          .add(PlatformEnum.ios)
          .add(PlatformEnum.android)
          .add(PlatformEnum.web)
      ..executables
          .add(name: 'myapp')
          .add(name: 'installer', script: 'install')
          .comments
          .append('')
      ..save(filename: 'example.yaml');
  });
}
