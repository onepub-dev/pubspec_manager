// ignore_for_file: avoid_setters_without_getters

import 'document.dart';
import 'key_value.dart';
import 'line.dart';
import 'line_type.dart';
import 'section.dart';

/// Used to hold a single line that cannot have
/// children, but may have comments.
class LineSection extends SectionImpl implements Section, Line {
  /// Build a [LineSection] from an attached line.
  LineSection.fromLine(super.line) : super.fromLine();

  // LineSection.fromLine(super.document, this.key, super.text, super.loneNo);

  LineSection.missing(super.document, super.key) : super.missing();

  @override
  String get text => line.text;

  @override
  LineType get type => line.type;

  @override
  String get value => line.value;

  List<Line> childrenOf({LineType? type, bool descendants = false}) =>
      line.childrenOf(type: type, descendants: descendants);

  set document(Document _document) {
    line.document = _document;
  }

  Line findKeyChild(String key) => line.findKeyChild(key);

  Line? findOneOf(List<String> keys) => line.findOneOf(keys);

  Line findRequiredKeyChild(String key) => line.findRequiredKeyChild(key);

  KeyValue get keyValue => line.keyValue;

  @override
  String render() => line.render();

  String renderInlineComment(int contentLength) =>
      line.renderInlineComment(contentLength);

  set commentOffset(int? _commentOffset) {
    line.commentOffset = _commentOffset;
  }

  set indent(int _indent) {
    line.indent = _indent;
  }

  set inlineComment(String? _inlineComment) {
    line.inlineComment = _inlineComment;
  }

  set lineNo(int _lineNo) {
    line.lineNo = _lineNo;
  }

  set text(String _text) {
    line.text = _text;
  }

  set type(LineType _type) {
    line.type = _type;
  }

  set value(String value) {
    line.value = value;
  }

  String get childIndent => line.childIndent;

  String get expand => line.expand;

  @override
  int? get commentOffset => line.commentOffset;

  @override
  int get indent => line.indent;

  @override
  String? get inlineComment => line.inlineComment;

  @override
  int get lineNo => line.lineNo;
}
