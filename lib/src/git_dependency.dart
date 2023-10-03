part of 'internal_parts.dart';

/// Git style dependency.
class GitDependency implements Dependency {
  GitDependency(
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

  /// Git dependencies don't have verions.
  @override
  String get version => '';

  late final Comments comments;

  @override
  GitDependencyAttached _attach(
          Dependencies dpendencies, Pubspec pubspec, int lineNo) =>
      GitDependencyAttached._attach(pubspec, lineNo, this);

  @override
  // ignore: avoid_setters_without_getters
  set version(String version) {
    // ignored as a git dep doesn't use a version.
  }
}
