part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
class PubHostedDependency implements Dependency {
  PubHostedDependency({required String name, required String version})
      : _name = name {
    try {
      _version = Version(version);
    } on FormatException catch (e) {
      throw VersionException(e.message);
    }
  }

  late String _name;
  late Version _version;

  set name(String name) {
    _name = name;
  }

  @override
  String get name => _name;

  @override
  Version get version => _version;

  @override
  DependencyAttached _attach(Pubspec pubspec, int lineNo) =>
      PubHostedDependencyAttached._attach(pubspec, lineNo, this);
}
