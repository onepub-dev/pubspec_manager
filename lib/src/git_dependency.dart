part of 'internal_parts.dart';

/// Git style dependency.
@immutable
class GitDependency implements Dependency {
  const GitDependency(
      {required this.name,
      this.url,
      this.ref,
      this.path,
      this.comments = const Comments.empty()});

  static const key = 'git';

  @override
  final String name;
  final String? url;
  final String? ref;
  final String? path;

  final Comments comments;

  @override
  GitDependencyAttached _attach(
          Dependencies dpendencies, Pubspec pubspec, int lineNo) =>
      GitDependencyAttached._attach(pubspec, lineNo, this);
}
