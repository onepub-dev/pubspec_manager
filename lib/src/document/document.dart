part of '../pubspec/internal_parts.dart';

/// A line based representation of the underlying
/// pubpsec.yaml. The [Document] holds a [Line] for
/// each line in the pubspec.yaml.
/// Any changes via the pubspec_manager api result
/// in changes to the list of [_lines].
/// You can use the [Document] to access settings
/// that are outside of the pubspec specification.
/// 
/// Changes made directly to the [Document] are not
/// reflected in the higher level APIs.
class Document {
  /// Load the pubspec.yaml from the file located at [pathTo]
  /// into a an ordered list of [Line]s.
  factory Document.loadFrom(String pathTo) {
    final lines = io.File(pathTo).readAsLinesSync();
    final doc = Document.loadFromLines(lines)..pathTo = pathTo;
    return doc;
  }

  /// Load the pubspec.yaml from the set of strings in [contentLines]
  /// into a an ordered list of [Line]s.
  Document.loadFromLines(List<String> contentLines) {
    var lineNo = 1;
    pathTo = '<Loaded from lines>';

    final topKeys = <String>{};

    for (final line in contentLines) {
      final lineImpl = LineImpl(this, line, lineNo++);
      _lines.add(lineImpl);

      /// check for duplicate top level keys.
      if (lineImpl.lineType == LineType.key && lineImpl.indent == 0) {
        // final keyIndent = _KeyIndent(lineImpl.key);
        if (topKeys.contains(lineImpl.key)) {
          throw DuplicateKeyException(
              lineImpl, "The key' ${lineImpl.key}' occurs more than once");
        }

        topKeys.add(lineImpl.key);
      }
    }
  }

  /// Load the pubspec.yaml from [content]
  /// into an ordered list of [Line]s.
  factory Document.loadFromString(String content) {
    var lines = content.split('\n');
    if (lines.isNotEmpty && Strings.isBlank(lines.last)) {
      // if the last char was \n then split returns an extra empty line
      lines = lines.sublist(0, lines.length - 1);
    }

    final doc = Document.loadFromLines(lines)
      ..pathTo = '<Loaded from a String>';
    return doc;
  }

  /// The set of lines that hold the pubspec.yaml
  final List<LineImpl> _lines = <LineImpl>[];

  List<Line> get lines => _lines;

  /// The path to the file that the pubspec.yaml was loaded from.
  late String pathTo;

  /// The last line in the document.
  Line? get lastLine => _lines.isEmpty ? null : _lines.last;

  /// Return the line that has the given [key].
  /// Only lines of type [LineType.key] are considered.
  LineSection getLineForKey(String key) {
    for (final line in _lines) {
      if (line.lineType == LineType.key) {
        if (line.key == key) {
          return LineSection.fromLine(line);
        }
      }
    }
    return LineSection.missing(this, key);
  }

  /// Finds a section for the given [key].
  /// If the [key] doesn't exist then returns null.
  Section findSectionForKey(String key) {
    for (final line in _lines) {
      if (line.lineType == LineType.key) {
        final keyValue = KeyValue.fromLine(line);
        if (keyValue.key == key) {
          return SectionImpl.fromLine(line);
        }
      }
    }
    return SectionImpl.missing(this, key);
  }

  /// Finds the line for the given [key].
  /// If the [key] isn't found then throws a [PubSpecException].
  LineSection getLineForRequiredKey(String key) {
    final line = getLineForKey(key);
    if (line.missing) {
      throw PubSpecException.forDocument(
          this, "Required key '$key' is missing.");
    }
    return line;
  }

  // Finds the next line that is of [LineType.key]
  // that is a child of the passed line which has the
  // given [key].  If no matching child is found then
  // null is returned.
  LineImpl findKeyChild(Line line, String key) {
    for (final child in childrenOf(line)) {
      if (child.keyValue.key == key) {
        return child;
      }
    }
    return LineImpl.missing(this, LineType.key);
  }

  /// Finds the first root key with the name [key]
  /// returns Line.missing if [key] was not found.
  LineImpl findTopLevelKey(String key) {
    for (final child in _lines) {
      if (child.indent != 0) {
        continue;
      }
      if (child.lineType != LineType.key) {
        continue;
      }

      if (child.keyValue.key == key) {
        return child;
      }
    }
    return LineImpl.missing(this, LineType.key);
  }

  /// Returns the list child for [parent].
  /// If [type] is passed, then only children of that type
  /// are returned.
  /// If [descendants] is true then all descendants of [parent]
  /// are returned not just immediate children.
  List<LineImpl> childrenOf(Line parent,
      {LineType? type, bool descendants = false}) {
    final children = <LineImpl>[];
    for (final line in _lines) {
      /// wait until we see a line that is after the parent.
      if (line.lineNo > parent.lineNo) {
        /// If the ident decreases then we have passed all
        /// of the parent's children.
        if (line.indent <= parent.indent) {
          break;
        }

        /// filter out children that don't match the key [type]
        if (type != null && line.lineType != type) {
          continue;
        }

        /// exclude descendants unless they were asked for.
        if (line.indent > parent.indent + 1 && !descendants) {
          continue;
        }

        children.add(line);
      }
    }
    return children;
  }

  /// Appends the passed line to the end of the document.
  /// The lines [Line.lineNo] will be updated to reflect
  /// the actual line number in the document.
  LineImpl append(LineDetached line) {
    final attached = line.attach(this)..lineNo = _lines.length + 1;
    _lines.add(attached);
    _validate();
    return attached;
  }

  /// Inserts [line] into the document after [lineBefore].
  /// The new lines lineNo will be inserted at [lineBefore].lineNo +1;
  /// The line numbers of subsequent lines are updated
  /// to reflect their new position.
  /// Returns the inserted line.
  LineImpl insertAfter(LineImpl line, Line lineBefore) {
    line.lineNo = lineBefore.lineNo + 1;
    assert(_lines.isNotEmpty,
        "We should never be able to get here as lineBefore wouldn't exist");

    if (lineBefore.lineNo == lastLine!.lineNo) {
      _lines.add(line);
    } else {
      _lines.insert(lineBefore.lineNo, line);
    }

    for (var i = line.lineNo; i < _lines.length; i++) {
      final _line = _lines.elementAt(i);
      _line.lineNo++;
    }
    _validate();
    return line;
  }

  /// Inserts a line before the passed [lineAfter]
  void insertBefore(LineImpl line, Line lineAfter) {
    line.lineNo = lineAfter.lineNo - 1;
    _lines.insert(line.lineNo, line);

    for (var i = line.lineNo; i < _lines.length; i++) {
      final _line = _lines.elementAt(i);
      _line.lineNo++;
    }
    _validate();
  }

  /// Removes all of the given [_lines] from the
  /// document then renumbers the remaining lines
  void removeAll(List<Line> toBeRemoved) {
    // ignore: prefer_foreach
    for (final line in toBeRemoved) {
      _lines.remove(line);
    }
    _reindex();
    _validate();
  }

  void _reindex() {
    var lineNo = 1;
    for (final line in _lines) {
      line.lineNo = lineNo++;
    }
  }

  void _validate() {
    var expectedLineNo = 1;
    for (final line in _lines) {
      if (line.lineNo != expectedLineNo) {
        throw PubSpecException(line, '''
Oops you found a bug. Expected $expectedLineNo found: ${line.lineNo}
with content:
$line ''');
      }
      expectedLineNo++;
    }
  }

  /// Check if [line] is attached to any section.
  /// Used when processing comments as it can be a little
  /// tricky to determine (base in indent) which section the
  /// comment is attached to.
  bool isAttachedToSection(LineImpl line) {
    for (final section in sections.values) {
      if (section.lines.contains(line)) {
        return true;
      }
    }
    return false;
  }

  /// registeres a comment as belonging to a section.
  void registerComment(LineImpl line, SectionImpl sectionImpl) {
    sections.putIfAbsent(line, () => sectionImpl);
  }

  /// List of sections that exist in this document.
  final sections = <Line, Section>{};
}

typedef Key = String;
