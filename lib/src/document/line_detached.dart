import 'document.dart';
import 'line.dart';

class LineDetached {
  LineDetached(this.text);
  String text;

  LineImpl attach(Document document) => LineImpl.forInsertion(document, text);
}
