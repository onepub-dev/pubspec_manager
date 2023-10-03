part of 'internal_parts.dart';

/// a hosted dependency which takes the form:
/// dependencies:
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// If no version is specified then 'any' is assumed.
@immutable
class HostedDependency implements Dependency {
  HostedDependency(
      {required String name,
      required String hosted,
      String? version,
      List<String> comments = const <String>[]}) {
    _name = name;
    hostedUrl = hosted;

    _version = Version.parse(version);
    this.comments = Comments(comments);
  }
  static const key = 'hosted';
  late final String _name;
  late final String hostedUrl;
  late final Version _version;

  String get version => _version.toString();

  @override
  String get name => _name;

  late final Comments comments;

  @override
  DependencyAttached _attach(
          Dependencies dependencies, Pubspec pubspec, int lineNo) =>
      HostedDependencyAttached.attach(dependencies, pubspec, lineNo, this);
}
