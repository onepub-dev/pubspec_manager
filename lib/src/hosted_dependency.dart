part of 'internal_parts.dart';

/// a hosted dependency which takes the form:
/// dependencies:
///   dcli:
///     hosted: https://onepub.dev
///     version: ^2.3.1
/// If no version is specified then 'any' is assumed.
@immutable
class HostedDependency implements Dependency {
  HostedDependency({
    required this.name,
    required String hosted,
    this.version,
    List<String>? comments,
  }) : _comments = comments ?? <String>[] {
    hostedUrl = hosted;
  }

  @override
  late final String name;
  late final String hostedUrl;
  late final String? version;
  late final List<String> _comments;

  List<String> get comments => _comments;

  @override
  DependencyAttached _attach(
          Dependencies dependencies, Pubspec pubspec, int lineNo) =>
      HostedDependencyAttached.attach(dependencies, pubspec, lineNo, this);
}
