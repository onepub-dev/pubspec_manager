part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
class PubHostedDependency implements Dependency {
  PubHostedDependency({
    required String name,
    required String version,
    List<String>? comments,
  })  : _name = name,
        _comments = comments ?? <String>[] {
    try {
      _version = Version(version);
    } on FormatException catch (e) {
      throw VersionException(e.message);
    }
  }

  late final List<String> _comments;

  late final String _name;
  late final Version _version;

  set name(String name) {
    _name = name;
  }

  @override
  String get name => _name;

  @override
  Version get version => _version;

  @override
  DependencyAttached _attach(
      Dependencies dependencies, Pubspec pubspec, int lineNo) {
    final attached = PubHostedDependencyAttached._attach(
        dependencies, pubspec, lineNo, this);
    // ignore: prefer_foreach
    for (final comment in _comments) {
      attached.comments.append(comment);
    }
    return attached;
  }
}
