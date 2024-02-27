part of '../pubspec/internal_parts.dart';

class SectionImpl implements Section {
  SectionImpl(this.headerLine, this._children) : missing = false {
    key = headerLine.key;
    comments = Comments(this);
  }

  SectionImpl.fromLine(this.headerLine) : missing = false {
    key = headerLine.key;
    _children = headerLine.childrenOf(descendants: true);
    comments = Comments(this);
  }

  SectionImpl.missing(Document document, this.key)
      : missing = true,
        headerLine = LineImpl.missing(document, LineType.key),
        _children = <Line>[] {
    comments = Comments.empty(this);
  }

  //
  // Fields
  //

  /// Line that represents the first line of the section
  /// excluding comments.
  @override
  LineImpl headerLine;

  @override
  late final String key;

  @override
  bool missing;

  /// the list of child lines that are nested within this
  /// section.
  /// Child lines are indented from the [headerLine]
  /// Does not include the [headerLine] nor any comments
  /// in the section prefix.
  late final List<Line> _children;

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
  @override
  Document get document => headerLine.document;

  /// returns the list of lines associated with this section
  /// including any comments immediately above the section.
  /// Comments may include blank lines and we return all
  /// lines upto the end of the prior segment.
  @override
  List<Line> get lines => [...comments.lines, headerLine, ..._children];

  /// List of comments associated (prepended) with this section
  @override
  late final Comments comments;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  /// Remove the [line] from the list of existing children.
  void _removeChild(Line line) {
    document.removeAll([line]);
    _children.remove(line);
  }

  void _clearChildren() {
    document.removeAll(_children);
    _children.clear();
  }

  /// Append a child line after all existing child lines
  /// of this [Section]
  void _appendLine(LineImpl line) {
    final lineBefore = _children.isEmpty ? headerLine : _children.last;
    _children.add(line);
    document.insertAfter(line, lineBefore);
  }
}

/// A section that may have children and comments.
/// Represent a section of a pubspec such as a dependency
/// and all lines attached to the dependency
/// Sections may be nested - e.g. The dependeny key is a
/// section as are each dependency under it.
/// A section is created by passing a [headerLine] which is
/// expected to be the start of the section. We then identify
/// associated lines that form that section.
abstract class Section {
  String get key;

  /// An missing section doesn't appear in the pubspec.yaml
  bool get missing;

  /// Returns the line that marks the start of a section.
  /// When determining the start of a section we ignore
  /// any comments and blank lines even though they are considered
  /// as part of the section.
  Line get headerLine;

  /// The [Document] that contains this section.
  Document get document;

  /// returns the list of lines associated with this section
  /// including any comments immediately above the section.
  /// Comments may include blank lines and we return all
  /// lines upto the end of the prior segment.
  List<Line> get lines;

  /// List of comments associated (prepended) with this section
  late final Comments comments;

  /// The last line number used by this  section
  int get lastLineNo;
}
