import 'document.dart';
import 'line.dart';
import 'line_type.dart';

class LineDetached {
  LineDetached(this.text);
  String text;

  /// If you don't pass the [lineType] then we will try to guess
  /// the line time. Allowing us to guess the line time is
  /// usually the right action unless the line is a secondary line
  /// for a multiline scalar string.
  LineImpl attach(Document document, [LineType? lineType]) =>
      LineImpl.forInsertion(document, text, lineType);
}
