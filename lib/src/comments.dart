part of 'internal_parts.dart';

/// A colletion of unattached comments
class Comments {
  Comments(this.comments);

  const Comments.empty() : comments = const <String>[];

  final List<String> comments;

  /// Comments are always attached to a section.
  CommentsAttached _attach(Section section) {
    final attached = CommentsAttached(section);

    // ignore: prefer_foreach
    for (final comment in comments) {
      attached.append(comment);
    }
    return attached;
  }
}
