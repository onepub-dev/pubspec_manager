// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:pub_semver/pub_semver.dart' as sm;
import 'package:strings/strings.dart';

import 'document/document.dart';
import 'document/line.dart';
import 'document/line_section.dart';
import 'pub_spec_exception.dart';

class Version extends LineSection {
  // factory Version(PubSpec pubspec, String version) {
  //   final line = Line.forInsertion(pubspec.document, 'version: $version');
  //   return Version.fromLine(line);
  // }

  factory Version.parse(String version) =>
      Version.fromLine(Line.forInsertion(version), required: true);

      
  // not part of the public interface
  Version.fromLine(this.line, {bool required = false}) : super.fromLine(line) {
    if (Strings.isBlank(line.value)) {
      if (required) {
        throw PubSpecException(line, 'Required version missing.');
      }
      // The pubspec doc says that a blank version is to be
      // treated as 'any'. We however need to record that the
      // version string was blank so we use emtpy.
      // However is the user queries the version we return any.
      _version = sm.VersionConstraint.empty;
      return;
    }
    _version = parseVersionConstraint(line, line.value);
  }

  Version.missing(Document document)
      : line = Line.missing(document),
        super.missing(document, 'version');

  @override
  late Line line;

  late sm.VersionConstraint _version;

  // The pubspec doc says that a blank version is to be
  // treated as 'any'. We however need to record that the
  // version string was blank so we use emtpy.
  // However is the user queries the version we return any.
  sm.VersionConstraint get constraint => _version == sm.VersionConstraint.empty
      ? sm.VersionConstraint.any
      : _version;

  @override
  String toString() => line.value;

  @override
  bool operator ==(Object other) =>
      other is Version &&
      other.runtimeType == runtimeType &&
      other._version == _version;

  @override
  int get hashCode => _version.hashCode;

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

  static sm.VersionConstraint parseVersionConstraint(Line line, String value) {
    try {
      return parse(_stripQuotes(value));
    } on VersionException catch (e) {
      e.document = line.document;
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  List<Line> get lines => [line];

  static void validate(String version) {
    parse(version);
  }

  static sm.VersionConstraint parse(String version) {
    try {
      return sm.VersionConstraint.parse(version);
    } on FormatException catch (e) {
      throw VersionException.global(e.message);
    }
  }
}

class VersionException extends PubSpecException {
  VersionException.global(super.message) : super.global();
}
