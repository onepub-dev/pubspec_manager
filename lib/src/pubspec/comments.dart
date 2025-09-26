part of 'internal_parts.dart';

/// Used to hold the comments that prefix a section.
/// A comment section is all the comments/blank lines that are above
/// a section that are not owned by a (prior) section.
///
/// ```yaml
/// name: test
/// # A comment which will be associated the version section.
/// version: 1.0.0
/// ```
/// Each section has a comments object associated with it.
///
/// ```dart
/// pubspec.name.comments.append('Another comment');
/// ```
class Comments {
  /// The section these comments are attached to.
  final SectionImpl _section;

  /// All of the lines that make up this comment.
  late final List<Line> _lines;

  Comments._(this._section) {
    _lines = _commentsAsLine();
  }

  Comments._empty(this._section) : _lines = <Line>[];

  /// Gets the set of comments that prefix the passed in [_section]
  /// This will include any blank lines upto the end of the prior
  /// section.
  List<Line> _commentsAsLine() {
    final document = _section.document;

    final prefix = <Line>[];

    final lines = document._lines;

    // search upwards for comments starting from the prior line
    var lineNo = _section.headerLine.lineNo - 2;

    final toRegister = <LineImpl>[];

    for (; lineNo > 0; lineNo--) {
      final line = lines[lineNo];
      final type = line.lineType;
      if (type == LineType.comment || type == LineType.blank) {
        if (!document.isAttachedToSection(line)) {
          prefix.insert(0, line);
          toRegister.add(line);
        }
      } else {
        break;
      }
    }

    /// we need to delay the registration as the section
    /// isn't fully initialised and registering a line
    /// to a non-initialised section causes [document.isAttachedToSection]
    /// to bail.
    for (final register in toRegister) {
      document.registerComment(register, _section);
    }
    return prefix;
  }

  /// The number of comment lines prepended to this section
  int get length => _lines.length;

  /// Unmodifiable List of comments. To modify the comment list
  /// use [append], [removeAt] and [removeAll].
  List<String> get comments =>
      List.unmodifiable(_lines.map((line) => line.value));

  /// Add [comment] to the PubSpec
  /// after the last line in this comment section.
  /// DO NOT prefix [comment] with a '#' as this
  /// method adds the '#'.
  Comments append(String comment) {
    final document = _section.headerLine._document;
    final commentLine = LineImpl.forInsertion(
        document, '${LineImpl.expandi(_section.headerLine.indent)}# $comment');
    _lines.add(commentLine);
    document.insertBefore(commentLine, _section.headerLine);
    return this;
  }

  /// Removes the comment a offset [index] in the list
  /// of comments for this [Section]. [index] is zero based.
  /// If no comment exists at [index] then a [RangeError] is thrown.
  void removeAt(int index) {
    final document = _section.document;
    if (index < 0) {
      throw OutOfBoundsException(
          _section.headerLine, 'Index must be >= 0 found $index}');
    }
    if (index > _lines.length) {
      throw OutOfBoundsException(_section.headerLine,
          'Index must be < ${_lines.length} found $index}');
    }

    final line = _lines.removeAt(index);
    document.removeAll([line]);
  }

  /// Remove all comments associated with this
  /// [Section].
  void removeAll() {
    _section.document.removeAll(_lines);
    _lines.removeRange(0, _lines.length);
  }
}
