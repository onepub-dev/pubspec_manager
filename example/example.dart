import 'package:eric/eric.dart';

void main() {
  final pubspec = PubSpec.fromFile()
  /// I think we need to have the concept of a detached Line
  /// so we can add the document as part of the attaching process.
    ..version.value = Version.parse('1.0.0')
    ..save();
}
