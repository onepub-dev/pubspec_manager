import 'comments.dart';
import 'document.dart';
import 'line.dart';
import 'section.dart';

class SimpleSection extends Section {
  SimpleSection(this.line, this._children) {
    _key = line.key;
    comments = Comments(this);
  }

  SimpleSection.fromLine(this.line) {
    _key = line.key;
    _children = line.childrenOf(descendants: true);
    comments = Comments(this);
  }

  SimpleSection.missing(Document document, this._key)
      : line = Line.missing(document),
        _children = <Line>[],
        super.missing() {
    comments = Comments.empty(this);
  }

  late final String _key;

  String get key => _key;

  @override
  Line line;
  late final List<Line> _children;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [...comments.lines, line, ..._children];

  @override
  late final Comments comments;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;
}
