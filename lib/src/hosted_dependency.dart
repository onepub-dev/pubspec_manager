part of 'internal_parts.dart';

/// a hosted dependency which takes the form:
/// dependencies:
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// If no version is specified then 'any' is assumed.
class HostedDependency implements Dependency {
  HostedDependency(
      {required String name, required String url, String? version}) {
    _name = name;
    hostedUrl = url;
    try {
      if (version != null) {
        _version = Version(version);
      } else {
        _version = Version.empty();
      }
    } on FormatException catch (e) {
      throw VersionException(e.message);
    }
  }
  static const key = 'hosted';
  late final String _name;
  late final String hostedUrl;
  late final Version _version;

  @override
  String get name => _name;

  @override
  Version get version => _version;

  @override
  DependencyAttached _attach(
          Dependencies dependencies, Pubspec pubspec, int lineNo) =>
      HostedDependencyAttached.attach(pubspec, lineNo, this);
}
