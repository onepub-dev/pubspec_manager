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
  LineSection.fromLine(super.sectionHeading) : super.fromLine();

  // LineSection.fromLine(super.document, this.key, super.text, super.loneNo);

  LineSection.missing(super.document, super.key) : super.missing();

  @override
  String get text => sectionHeading.text;

  @override
  LineType get type => sectionHeading.type;

  @override
  String get value => sectionHeading.value;

  List<Line> childrenOf({LineType? type, bool descendants = false}) =>
      sectionHeading.childrenOf(type: type, descendants: descendants);

  set document(Document _document) {
    sectionHeading.document = _document;
  }

  Line findKeyChild(String key) => sectionHeading.findKeyChild(key);

  Line? findOneOf(List<String> keys) => sectionHeading.findOneOf(keys);

  Line findRequiredKeyChild(String key) =>
      sectionHeading.findRequiredKeyChild(key);

  KeyValue get keyValue => sectionHeading.keyValue;

  @override
  String render() => sectionHeading.render();

  String renderInlineComment(int contentLength) =>
      sectionHeading.renderInlineComment(contentLength);

  set commentOffset(int? _commentOffset) {
    sectionHeading.commentOffset = _commentOffset;
  }

  set indent(int _indent) {
    sectionHeading.indent = _indent;
  }

  set inlineComment(String? _inlineComment) {
    sectionHeading.inlineComment = _inlineComment;
  }

  set lineNo(int _lineNo) {
    sectionHeading.lineNo = _lineNo;
  }

  set type(LineType _type) {
    sectionHeading.type = _type;
  }

  set value(String value) {
    sectionHeading.value = value;
  }

  String get childIndent => sectionHeading.childIndent;

  String get expand => sectionHeading.expand;

  @override
  int? get commentOffset => sectionHeading.commentOffset;

  @override
  int get indent => sectionHeading.indent;

  @override
  String? get inlineComment => sectionHeading.inlineComment;

  @override
  int get lineNo => sectionHeading.lineNo;
}
