// ignore_for_file: avoid_setters_without_getters
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

  @override
  String render() => headerLine.render();

  String renderInlineComment(int contentLength) =>
      headerLine.renderInlineComment(contentLength);

  set commentOffset(int? _commentOffset) {
    headerLine.commentOffset = _commentOffset;
  }

  set indent(int _indent) {
    headerLine.indent = _indent;
  }

  set inlineComment(String? _inlineComment) {
    headerLine.inlineComment = _inlineComment;
  }

  set lineNo(int _lineNo) {
    headerLine.lineNo = _lineNo;
  }

  set lineType(LineType _type) {
    headerLine.lineType = _type;
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
