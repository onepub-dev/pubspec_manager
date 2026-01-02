part of '../pubspec/internal_parts.dart';

/// A SectionImpl is created by passing a [headerLine] which is
/// expected to be the start of the section. We then identify
/// associated lines that form that section.
class SectionImpl implements Section {
  /// Returns the line that marks the start of a section.
  /// When determining the [headerLine] of a section we ignore
  /// any comments and blank lines even though they are considered
  /// as part of the section.
  LineImpl headerLine;

  final String key;

  /// If there is no section with this key in the document
  /// then it is marked as missing.
  @override
  bool missing;

  /// the list of child lines that are nested within this
  /// section.
  /// Child lines are indented from the [headerLine]
  /// Does not include the [headerLine] nor any comments
  /// in the section prefix.
  final List<Line> _children;

  /// List of comments associated (prepended) with this section
  @override
  late final Comments comments;

  SectionImpl(this.headerLine, this._children)
      : key = headerLine.key,
        missing = false {
    comments = Comments._(this);
  }

  SectionImpl.fromLine(this.headerLine)
      : key = headerLine.key,
        _children = headerLine.childrenOf(descendants: true),
        missing = false {
    comments = Comments._(this);
  }

  SectionImpl.missing(Document document, this.key)
      : missing = true,
        headerLine = LineImpl.missing(document, LineType.key),
        _children = <Line>[] {
    comments = Comments._empty(this);
  }

  ///
  /// Methods
  ///
  // LineImpl insertAfter(LineImpl line, Line lineBefore) {
  //   assert(lines.contains(lineBefore), 'lineBefore must be in this section');
  //   line = document.insertAfter(line, lineBefore);

  //   /// we could perhaps do this more efficiently by
  //   /// finding where to insert the line into our
  //   /// existing copy of _children, but this is easier.
  //   _children
  //     ..clear()
  //     ..addAll(line.childrenOf(descendants: true));

  //   missing = false;

  //   return line;
  // }

  /// The [Document] that contains this section.
  Document get document => headerLine._document;

  /// returns the list of lines associated with this section
  /// including any comments immediately above the section.
  /// Comments may include blank lines and we return all
  /// lines upto the end of the prior segment.
  @override
  List<Line> get lines => [...comments._lines, headerLine, ..._children];

  /// The last line number used by this  section
  int get lastLineNo => lines.last.lineNo;

  /// Remove the [line] from the list of existing children.
  void _removeChild(Line line) {
    document.removeAll([line]);
    _children.remove(line);
  }

  void clearChildren() {
    document.removeAll(_children);
    _children.clear();
  }

  /// Append a child line after all existing child lines
  /// of this [Section]
  void appendLine(LineImpl line) {
    final lineBefore = _children.isEmpty ? headerLine : _children.last;
    _children.add(line);
    document.insertAfter(line, lineBefore);
  }
}
