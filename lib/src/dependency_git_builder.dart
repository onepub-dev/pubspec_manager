part of 'internal_parts.dart';

/// Git style dependency.
@immutable
class DependencyGitBuilder implements DependencyBuilder {
  DependencyGitBuilder({
    required this.name,
    this.url,
    this.ref,
    this.path,
    List<String>? comments,
  }) : _comments = comments ?? <String>[];

  @override
  final String name;
  final String? url;
  final String? ref;
  final String? path;
  late final List<String> _comments;

  List<String> get comments => _comments;

  @override
  DependencyGit _attach(
          Dependencies dpendencies, PubSpec pubspec, Line lineBefore) =>
      DependencyGit._attach(pubspec, lineBefore, this);
}
