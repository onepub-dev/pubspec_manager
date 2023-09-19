import 'document.dart';
import 'line.dart';

class LineDetached {
  LineDetached(this.text);
  String text;

  Line attach(Document document) => Line.forInsertion(document, text);
}
