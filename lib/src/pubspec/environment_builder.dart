part of 'internal_parts.dart';

/// Used to build an [Environment] when constructing
/// a [PubSpec].
///
/// ```dart
///   PubSpec(
///       name: 'new eric',
///       version: '1.0.0-alpha.2',
///       description: 'An example',
///       environment:
///           EnvironmentBuilder(sdk: '>3.0.0 <=4.0.0', flutter: '1.0.0'),
///       );
/// ```
/// Holds the details of the environment section.
/// i.e. flutter and sdk versions.
///
class EnvironmentBuilder {
  final String? _sdk;

  final String? _flutter;

  /// True if the 'environment' key is missing from the pubspec.
  final bool missing;

  /// Creates an environment key with an [sdk] version constraint and/or
  /// a [flutter] version constraint.
  /// ```dart
  /// EnvironmentBuilder(sdk: '>3.0.0 <=4.0.0')
  /// ```
  /// You can optionally pass in [sdk] to set the sdk version constraint
  ///   and/or [flutter] to set the flutter version costraint.
  EnvironmentBuilder({String? sdk, String? flutter})
      : _sdk = sdk,
        _flutter = flutter,
        missing = false;

  // Used to indicate that an environment wasn't specified
  EnvironmentBuilder._missing()
      : _sdk = null,
        _flutter = null,
        missing = true;

  Environment _attach(PubSpec pubspec, Line lineBefore) {
    if (missing) {
      return Environment._missing(pubspec.document);
    }
    return Environment._insertAfter(pubspec, lineBefore, this);
  }
}
