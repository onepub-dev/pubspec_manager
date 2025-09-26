part of 'internal_parts.dart';

/// represents an executable
/// executable:
///   dcli: dcli_tool
class ExecutableBuilder {
  /// name of the executable
  String name;

  /// The project relative path to the dart script.
  /// Not required if the [name] is the name of a script
  /// in the projects bin directory.
  String script;

  ExecutableBuilder({required this.name, String? script})
      : script = script ?? '';

  Executable _attach(PubSpec pubspec, Line lineBefore) =>
      Executable._attach(pubspec, lineBefore, this);
}
