part of 'internal_parts.dart';

/// Git style dependency.
@immutable
class DependencyBuilderGit implements DependencyBuilder {
  @override
  final String name;

  final String url;

  final String? ref;

  final String? path;

  late final List<String> _comments;

  DependencyBuilderGit({
    required this.name,
    required this.url,
    this.ref,
    this.path,
    List<String>? comments,
  }) : _comments = comments ?? <String>[];

  /// List of comments to be prepended to the
  /// dependency.
  List<String> get comments => _comments;

  bool get isSimple => ref == null && path == null;

  @override
  DependencyGit _attach(
          Dependencies dpendencies, PubSpec pubspec, Line lineBefore) =>
      DependencyGit._insertAfter(pubspec, lineBefore, this);
}
