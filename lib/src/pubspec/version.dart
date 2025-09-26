// considered low risk.
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

part of 'internal_parts.dart';

/// Holds package version (not a dependency package)
/// as declared in the pubspec.yaml
class Version implements Section {
  SectionImpl _section;

  var quoted = false;

  sm.Version _semVersion = sm.Version.none;

  static const keyName = 'version';

  ///
  /// extract the version from the underlying document.

  factory Version._fromDocument(Document document) {
    final line = document.findTopLevelKey(Version.keyName);
    //  final lineSection = document.getLineForKey(Version.keyName);
    if (line.missing) {
      return Version._missing(document);
    } else {
      return Version._(line);
    }
  }

  /// Define a missing version.
  Version._missing(Document document)
      : _section = SectionImpl.missing(document, keyName);

  Version._(LineImpl line) : _section = SectionSingleLine.fromLine(line) {
    _semVersion = parseSemVersion(_section.headerLine.value);
  }

  /// There was a version key but no value
  bool get isEmpty => !_section.missing && _semVersion.isEmpty;

  /// There was no version in the pubspec.
  bool get isMissing => _section.missing;

  /// If a version has not been specified we return [sm.Version.none]
  sm.Version get semVersion =>
      _semVersion.isEmpty || _section.missing ? sm.Version.none : _semVersion;

  void setSemVersion(sm.Version value) {
    _semVersion = value;
    _section.headerLine.value = value.toString();
  }

  String get value {
    if (quoted) {
      return "'$semVersion'";
    } else {
      return semVersion.toString();
    }
  }

  @override
  String toString() => value;

  Version set(String version) {
    /// check for a valid version.
    try {
      _semVersion = sm.Version.parse(version);
    } on FormatException catch (e) {
      throw VersionException('The passed version is invalid: ${e.message}');
    }
    quoted = _isQuoted(version);

    if (missing) {
      _section
        ..missing = false
        ..headerLine =
            _section.document.append(LineDetached('$keyName: $version'));
    } else {
      _section.headerLine.value = _stripQuotes(version);
    }

    return this;
  }

  static bool _isQuoted(String version) =>
      version.contains("'") || version.contains('"');

  @override
  bool operator ==(Object other) =>
      other is Version &&
      other.runtimeType == runtimeType &&
      other._semVersion == _semVersion;

  @override
  int get hashCode => _semVersion.hashCode;

  // strips any quotes that surround the value
  static String _stripQuotes(String value) {
    if (value.isEmpty) {
      return value;
    }
    final first = value.substring(0, 1);

    // the version may have no quotes.
    if (first != "'" && first != '"') {
      return value;
    }

    // find the matching quote.
    final last = value.substring(value.length - 1, value.length);

    if (first == "'" || first == '"') {
      if (first != last) {
        throw PubSpecException.global(
            'The quotes around the version $value  do not match');
      }
      return value.substring(1, value.length - 1);
    }

    return value;
  }

  static sm.Version parseSemVersion(String value) =>
      sm.Version.parse(_stripQuotes(value));

  @override
  Comments get comments => _section.comments;

  @override
  List<Line> get lines => _section.lines;

  @override
  bool get missing => _section.missing;
}
