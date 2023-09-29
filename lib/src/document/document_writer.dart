import 'dart:io';

import '../../eric.dart';
import 'document.dart';
import 'line.dart';
import 'section.dart';

class DocumentWriter {
  DocumentWriter(this.document);
  Document document;
  Map<int, Line> lines = <int, Line>{};

  void writeDoc() {}

  void render(Section? section) {
    if (section == null) {
      return;
    }
    for (final line in section.lines) {
      if (line.missing) {
        continue;
      }
      if (lines.containsKey(line.lineNo)) {
        throw PubSpecException(
            line, 'Oops you found a bug. Duplicate line no ${line.lineNo}');
      }
      lines.putIfAbsent(line.lineNo, () => line);
    }
  }

  /// Write the contents of the pubspec.yaml to the file
  /// at [pathTo].
  void write(String pathTo) {
    final file = File(pathTo);
    final sorted = lines.keys.toList()..sort((a, b) => a - b);
    if (file.existsSync()) {
      file.deleteSync();
    }
    for (final lineNo in sorted) {
      final line = lines[lineNo];
      file.writeAsStringSync('${line!.render()} $_lineTerminator',
          mode: FileMode.append);
    }
  }

  /// Platform specific line terminator.
  static String get _lineTerminator {
    if (Platform.isWindows) {
      return '\r\n';
    } else {
      return '\n';
    }
  }

  /// Any lines which are independent of known keys will not have
  /// been rendered so now we render them verbatum.
  void renderMissing() {
    final missing = <int, Line>{};
    for (var lineNo = 1; lineNo <= document.lines.length; lineNo++) {
      if (lines.containsKey(lineNo)) {
        continue;
      }

      final line = document.lines.elementAt(lineNo - 1);
      missing.putIfAbsent(lineNo, () => line);
    }
    lines.addAll(missing);
  }
}
