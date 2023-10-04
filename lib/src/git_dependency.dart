part of 'internal_parts.dart';

/// Git style dependency.
@immutable
class GitDependency implements Dependency {
  GitDependency({
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
  GitDependencyAttached _attach(
          Dependencies dpendencies, Pubspec pubspec, int lineNo) =>
      GitDependencyAttached._attach(pubspec, lineNo, this);
}
