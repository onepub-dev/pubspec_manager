import '../internal_parts.dart';
import 'document.dart';
import 'key_value.dart';
import 'line.dart';
import 'line_type.dart';
import 'section.dart';

/// Used to hold a single line that cannot have
/// children, but may have comments.
class LineSection implements Section, Line {
  LineSection.fromLine(Line line)
      : _line = line,
        key = line.key {
    comments = CommentsAttached(this);
  }

  // LineSection.fromLine(super.document, this.key, super.text, super.loneNo);

  LineSection.missing(Document document, this.key)
      : _line = Line.missing(document, LineType.key) {
    comments = CommentsAttached.empty(this);
  }

  final Line _line;

  @override
  String key;

  @override
  Line get line => _line;

  @override
  List<Line> get lines => [...comments.lines, line];

  @override
  late final CommentsAttached comments;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  @override
  bool get missing => _line.missing;

  @override
  Document get document => _line.document;

  @override
  set missing(bool _missing) => _line.missing;

  @override
  int? get commentOffset => _line.commentOffset;

  @override
  int get indent => _line.indent;

  @override
  String? get inlineComment => _line.inlineComment;

  @override
  int get lineNo => _line.lineNo;

  @override
  String get text => _line.text;

  @override
  LineType get type => _line.type;

  @override
  String get value => _line.value;

  @override
  List<Line> childrenOf({LineType? type, bool descendants = false}) =>
      _line.childrenOf(type: type, descendants: descendants);

  @override
  set document(Document _document) {
    _line.document = _document;
  }

  @override
  Line findKeyChild(String key) => _line.findKeyChild(key);

  @override
  Line? findOneOf(List<String> keys) => _line.findOneOf(keys);

  @override
  Line findRequiredKeyChild(String key) => _line.findRequiredKeyChild(key);

  @override
  KeyValue get keyValue => _line.keyValue;

  @override
  String render() => _line.render();

  @override
  String renderInlineComment(int contentLength) =>
      _line.renderInlineComment(contentLength);

  @override
  set commentOffset(int? _commentOffset) {
    _line.commentOffset = _commentOffset;
  }

  @override
  set indent(int _indent) {
    _line.indent = _indent;
  }

  @override
  set inlineComment(String? _inlineComment) {
    _line.inlineComment = _inlineComment;
  }

  @override
  set lineNo(int _lineNo) {
    _line.lineNo = _lineNo;
  }

  @override
  set text(String _text) {
    _line.text = _text;
  }

  @override
  set type(LineType _type) {
    _line.type = _type;
  }

  @override
  set value(String value) {
    _line.value = value;
  }
}
