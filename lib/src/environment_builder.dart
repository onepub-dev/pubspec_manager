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
        _flutter = flutter;

  // Used to indicate that an environment wasn't specified
  EnvironmentBuilder.missing();

  Environment _attach(PubSpec pubspec, int lineNo) =>
      Environment._attach(pubspec, lineNo, this);

  late final String? _sdk;
  late final String? _flutter;
}
