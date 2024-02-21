part of 'internal_parts.dart';

/// Holds the details of the environment section.
/// i.e. flutter and sdk versions.
///
class EnvironmentBuilder {
  /// Creates an environment key with an [sdk] version constraint and/or
  /// a [flutter] version constraint.
  /// ```dart
  /// Environment(sdk: '>3.0.0 <=4.0.0')
  /// ```
  EnvironmentBuilder({String? sdk, String? flutter})
      : _sdk = sdk,
        _flutter = flutter,
        missing = false;

  // Used to indicate that an environment wasn't specified
  EnvironmentBuilder.missing()
      : _sdk = null,
        _flutter = null,
        missing = true;

  Environment _attach(PubSpec pubspec, Line lineBefore) {
    if (missing) {
      return Environment.missing(pubspec.document);
    }
    return Environment._insertAfter(pubspec, lineBefore, this);
  }

  final String? _sdk;
  final String? _flutter;
  final bool missing;
}
