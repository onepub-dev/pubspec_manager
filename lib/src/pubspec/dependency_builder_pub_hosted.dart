part of 'internal_parts.dart';

/// A dependench hosted on pub.dev.
/// A pub hosted dependency is of the form
/// dependencies:
///   dcli: ^3.0.1
///
@immutable
class DependencyBuilderPubHosted implements DependencyBuilder {
  @override
  final String name;

  /// The version constraint for the dependency
  /// e.g. ^1.0.0
  final String? versionConstraint;

  final List<String> _comments;

  /// If you don't pass in a [versionConstraint] then the version will
  /// be left empty when you save
  /// The [name] of the dependency to add.
  /// The [versionConstraint] such as
  DependencyBuilderPubHosted({
    required this.name,
    this.versionConstraint,
    List<String>? comments,
  }) : _comments = comments ?? <String>[];

  /// List of comments to be prepended to the
  /// dependency.
  List<String> get comments => _comments;

  @override
  Dependency _attach(
      Dependencies dependencies, PubSpec pubspec, Line lineBefore) {
    final attached = DependencyPubHosted._insertAfter(
        dependencies, pubspec, lineBefore, this);

    return attached;
  }
}
