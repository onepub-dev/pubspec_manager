part of 'internal_parts.dart';

/// A builder that generates an [DependencyAltHosted] ready to be attached
/// to the pubspec.
/// If no version is specified then 'any' is assumed.
///
/// Use this method with [Dependencies.add] to add a dependencies.
/// ```dart
/// pubspec.devDependencies.append(
///     DependencyAltHostedBuilder(name: 'fred',
///       hostedUrl: https://onepub.dev/packages/dcli,
///       versionConstraint: '^1.0.0'));
/// ```
@immutable
class DependencyBuilderAltHosted implements DependencyBuilder {
  @override
  final String name;

  /// The url describing the location where the dependency is hosted.
  /// e.g. `https://onepub.dev/packages/dcli`
  final String hostedUrl;

  /// The version constraint for the dependency
  /// e.g. ^1.0.0
  final String? versionConstraint;

  final List<String> _comments;

  DependencyBuilderAltHosted({
    required this.name,
    required this.hostedUrl,
    this.versionConstraint,
    List<String>? comments,
  }) : _comments = comments ?? <String>[];

  /// The list of comments to be associated with
  /// the dependency.
  List<String> get comments => _comments;

  @override
  Dependency _attach(
          Dependencies dependencies, PubSpec pubspec, Line lineBefore) =>
      DependencyAltHosted._insertAfter(dependencies, pubspec, lineBefore, this);
}
