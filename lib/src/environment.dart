import '../eric.dart';
import 'document/comments.dart';
import 'document/document.dart';
import 'document/line.dart';
import 'document/section.dart';

/// Holds the details of the environment section.
/// i.e. flutter and sdk versions.
class Environment extends Section {
  Environment.missing(Document document)
      : environment = Line.missing(document),
        super.missing();

  /// Load the environment [Section] starting from the
  /// given [environment].
  Environment.fromLine(this.environment) {
    final sdkLine = environment.findRequiredKeyChild('sdk');
    sdk = Version.fromLine(sdkLine, required: true);

    final flutterLine = environment.findKeyChild('flutter');
    if (flutterLine != null) {
      flutter = Version.fromLine(flutterLine, required: true);
    } else {
      flutter = Version.missing(document);
    }

    comments = Comments(this);
  }

  /// The starting line of the environment section.
  Line environment;
  late final Version sdk;
  late final Version flutter;

  @override
  Line get line => environment;

  @override
  late final Comments comments;

  @override
  String toString() => environment.value;

  @override
  Document get document => line.document;

  @override
  List<Line> get lines => [environment, ...sdk.lines, ...flutter.lines];
}
