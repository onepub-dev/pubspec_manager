import 'comments.dart';
import 'line.dart';
import 'section.dart';

/// Used to hold a single line that cannot have
/// children, but may have comments.
class LineSection extends Line implements Section {
  LineSection.fromLine(super.line)
      : key = line.key,
        super.copy() {
    comments = Comments(this);
  }
  LineSection.missing(super.document, this.key) : super.missing() {
    comments = Comments.empty(this);
  }

  @override
  String key;

  @override
  Line get line => this;

  @override
  List<Line> get lines => [...comments.lines, line];

  @override
  late final Comments comments;
}
