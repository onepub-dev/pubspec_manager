part of 'internal_parts.dart';

/// Holds the details of the environment section.
/// i.e. flutter and sdk versions.
///
class Environment {
  /// Creates an environment key with an [sdk] version constraint and/or
  /// a [flutter] version constraint.
  /// ```dart
  /// Environment(sdk: '>3.0.0 <=4.0.0')
  /// ```
  Environment({String? sdk, String? flutter})
      : _sdk = sdk,
        _flutter = flutter;

  // Used to indicate that an environment wasn't specified
  Environment.missing();

  EnvironmentAttached _attach(Pubspec pubspec, int lineNo) =>
      EnvironmentAttached._attach(pubspec, lineNo, this);

  late final String? _sdk;
  late final String? _flutter;
}
