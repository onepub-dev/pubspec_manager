part of 'internal_parts.dart';

mixin DependencyMixin implements Dependency {
  /// List of comments associated with the
  /// dependency.
  @override
  Comments get comments => _section.comments;

  /// The line number within the pubspec.yaml
  /// where this dependency is located.
  @override
  int get lineNo => _section.headerLine.lineNo;
}
