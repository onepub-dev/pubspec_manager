part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
///
@immutable
class PubHostedDependencyBuilder implements DependencyBuilder {
  /// If you don't pass in a [version] then the version will
  /// be left empty when you save
  PubHostedDependencyBuilder({
    required this.name,
    this.version,
    List<String>? comments,
  }) : _comments = comments ?? <String>[];

  @override
  late final String name;
  late final String? version;
  late final List<String> _comments;

  List<String> get comments => _comments;

  @override
  Dependency _attach(
      Dependencies dependencies, PubSpec pubspec, Line lineBefore) {
    final attached =
        PubHostedDependency._attach(dependencies, pubspec, lineBefore, this);

    return attached;
  }
}
