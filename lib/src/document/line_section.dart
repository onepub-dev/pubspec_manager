part of '../pubspec/internal_parts.dart';

/// Used to hold a single line that cannot have
/// children, but may have comments.
class LineSection extends SectionImpl implements Section, Line {
  /// Build a [LineSection] from an attached line.
  LineSection.fromLine(super.headerLine) : super.fromLine();

  // LineSection.fromLine(super.document, this.key, super.text, super.loneNo);

  LineSection.missing(super.document, super.key) : super.missing();

  @override
  String get text => headerLine.text;

  @override
  LineType get lineType => headerLine.lineType;

  @override
  String get value => headerLine.value;

  List<Line> childrenOf({LineType? type, bool descendants = false}) =>
      headerLine.childrenOf(type: type, descendants: descendants);

  Line findKeyChild(String key) => headerLine.findKeyChild(key);

  Line? findOneOf(List<String> keys) => headerLine.findOneOf(keys);

  Line findRequiredKeyChild(String key) => headerLine.findRequiredKeyChild(key);

  KeyValue get keyValue => headerLine.keyValue;

  String render() => headerLine.render();

  String renderInlineComment(int contentLength) =>
      headerLine.renderInlineComment(contentLength);

  set commentOffset(int? commentOffset) {
    headerLine.commentOffset = commentOffset;
  }

  set indent(int indent) {
    headerLine.indent = indent;
  }

  set inlineComment(String? inlineComment) {
    headerLine.inlineComment = inlineComment;
  }

  set lineNo(int lineNo) {
    headerLine.lineNo = lineNo;
  }

  set lineType(LineType type) {
    headerLine.lineType = type;
  }

  set value(String value) {
    headerLine.value = value;
  }

  String get childIndent => headerLine.childIndent;

  String get expand => headerLine._expand;

  @override
  int? get commentOffset => headerLine.commentOffset;

  @override
  int get indent => headerLine.indent;

  @override
  String? get inlineComment => headerLine.inlineComment;

  @override
  int get lineNo => headerLine.lineNo;
}
