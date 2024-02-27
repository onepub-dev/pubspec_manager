part of 'internal_parts.dart';

/// represents an executable
/// executable:
///   dcli: dcli_tool
class ExecutableBuilder {
  ExecutableBuilder({required this.name, String? script})
      : script = script ?? '';

  ExecutableBuilder.missing()
      : name = '',
        script = '';

  String name;
  String script;

  Executable _attach(PubSpec pubspec, Line lineBefore) =>
      Executable._attach(pubspec, lineBefore, this);
}
