part of 'internal_parts.dart';

/// a hosted dependency which takes the form:
/// dependencies:
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// If no version is specified then 'any' is assumed.
class HostedDependency implements Dependency {
  HostedDependency(
      {required String name,
      required String url,
      String? version = 'any',
      List<String> comments = const <String>[]}) {
    _name = name;
    hostedUrl = url;

    _versionConstraint = Version.parseConstraint(version);
    this.comments = Comments(comments);
  }
  static const key = 'hosted';
  late final String _name;
  late final String hostedUrl;
  late final sm.VersionConstraint _versionConstraint;

  String get version => _versionConstraint.toString();

  // @override
  // sm.VersionConstraint get versionConstraint =>
  //     _versionConstraint == sm.VersionConstraint.empty
  //         ? sm.VersionConstraint.any
  //         : _versionConstraint;

  @override
  String get name => _name;

  late final Comments comments;

  @override
  DependencyAttached _attach(
          Dependencies dependencies, Pubspec pubspec, int lineNo) =>
      HostedDependencyAttached.attach(pubspec, lineNo, this);
}
