import '../internal_parts.dart';
import 'document.dart';
import 'line.dart';
import 'line_type.dart';

class SectionImpl implements Section {
  SectionImpl(this.line, this._children) : missing = false {
    _key = line.key;
    comments = Comments(this);
  }

  SectionImpl.fromLine(this.line) : missing = false {
    _key = line.key;
    _children = line.childrenOf(descendants: true);
    comments = Comments(this);
  }

  SectionImpl.missing(Document document, this._key)
      : missing = true,
        line = LineImpl.missing(document, LineType.key),
        _children = <Line>[] {
    comments = Comments.empty(this);
  }

  ///
  /// Fields
  ///
  @override
  LineImpl line;

  late final String _key;

  @override
  String get key => _key;

  @override
  bool missing;

  /// the list of child lines that are nested within this
  /// section.
  /// Does not include the [line] nor any comments
  /// in the section prefix.
  late final List<Line> _children;

  ///
  /// Methods
  ///
  LineImpl insertAfter(LineImpl line, Line lineBefore) {
    assert(lines.contains(lineBefore), 'lineBefore must be in this section');
    line = document.insertAfter(line, lineBefore);

    /// we could perhaps do this more efficiently by
    /// finding where to insert the line into our
    /// existing copy of _children, but this is easier.
    _children
      ..clear()
      ..addAll(line.childrenOf(descendants: true));

    return line;
  }

  /// The [Document] that contains this section.
  @override
  Document get document => line.document;

  /// returns the list of lines associated with this section
  /// including any comments immediately above the section.
  /// Comments may include blank lines and we return all
  /// lines upto the end of the prior segment.
  @override
  List<Line> get lines => [...comments.lines, line, ..._children];

  /// List of comments associated (prepended) with this section
  @override
  late final Comments comments;

  /// The last line number used by this  section
  @override
  int get lastLineNo => lines.last.lineNo;

  void remove(Line line) {
    _children.remove(line);
  }
}

/// A section that may have children and comments.
/// Represent a section of a pubspec such as a dependency
/// and all lines attached to the dependency
/// Sections may be nested - e.g. The dependeny key is a
/// section as are each dependency under it.
/// A section is created by passing a [line] which is
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
  Line get line;

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
