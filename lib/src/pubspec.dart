import 'dart:io';

import 'package:path/path.dart';

import '../eric.dart';
import 'dependencies.dart';
import 'document/document.dart';
import 'document/document_writer.dart';
import 'document/line_detached.dart';
import 'document/line_section.dart';
import 'document/line_type.dart';
import 'document/multi_line.dart';
import 'document/simple_section.dart';

class PubSpec {
  /// Create an in memory pubspec.yaml.
  /// It can be saved to disk by calling [save].
  PubSpec(this.name, this.version, this.description, this.environment) {
    dependencies = Dependencies(this, 'dependencies');

    document
      ..append(LineDetached('name:$name'))
      ..append(LineDetached('version:$version'))
      ..append(LineDetached('description:$description'));

    environment = Environment.missing(document);
    homepage = LineSection.missing(document, 'homepage');
    repository = LineSection.missing(document, 'repository');
    issueTracker = LineSection.missing(document, 'issueTracker');
    documentation = LineSection.missing(document, 'documentation');
    dependencies = Dependencies.missing(this, 'dependencies');
    devDependencies = Dependencies.missing(this, 'dev_dependencies');
    dependencyOverrides = Dependencies.missing(this, 'dependency_overrides');
    platforms = SimpleSection.missing(document, 'platforms');
    executables = SimpleSection.missing(document, 'executables');
    funding = SimpleSection.missing(document, 'funding');
    falseSecrets = SimpleSection.missing(document, 'false_secrets');
    screenshots = SimpleSection.missing(document, 'screenshots');
    topics = SimpleSection.missing(document, 'topics');
  }

  /// Loads the content of a pubspec.yaml from [content].
  PubSpec.fromString(String content) {
    document = Document.loadFromString(content);

    name = document.getLineForRequiredKey('name');
    version = Version.fromLine(document.getLineForRequiredKey('version'));
    description = document.getMultiLineForRequiredKey('description');
    environment =
        Environment.fromLine(document.getLineForRequiredKey('environment'));
    homepage = document.getLineForKey('homepage');
    repository = document.getLineForKey('repository');
    issueTracker = document.getLineForKey('issueTracker');
    documentation = document.getLineForKey('documentation');

    dependencies = _initDependencies('dependencies');
    devDependencies = _initDependencies('dev_dependencies');
    dependencyOverrides = _initDependencies('dependency_overrides');
    platforms = document.findSectionForKey('platforms');

    executables = document.findSectionForKey('executables');
    funding = document.findSectionForKey('funding');
    falseSecrets = document.findSectionForKey('falseSecrets');
    screenshots = document.findSectionForKey('screenshots');
    topics = document.findSectionForKey('topics');
  }

  /// Loads the pubspec.yaml file from the given [directory].
  /// If you pass [filename] then it can be loaded from
  /// a non-standard filename.
  /// If you don't pass [filename] then we will attempt to load
  /// the pubspec from the file 'pubspec.yaml'.
  ///
  /// If the pubspec is not found in the given directory we search
  /// up the directory tree looking for it.
  ///
  /// If you don't provide a[directory] then we start the search
  /// from the current working directory.
  factory PubSpec.fromFile(
      {String? directory, String filename = 'pubspec.yaml'}) {
    final loadedFrom =
        _findPubSpecFile(directory ?? Directory.current.path, filename);
    final content = File(loadedFrom).readAsStringSync();

    final pubspec = PubSpec.fromString(content)
      .._loadedFromDirectory = dirname(loadedFrom)
      .._loadedFromFilename = basename(loadedFrom);
    return pubspec;
  }

  // the path the pubspec.yaml was loaded from (including the filename)
  // If the pubpsec wasn't loaded from a file then this will be null.
  String? _loadedFromDirectory;
  String? _loadedFromFilename;

  /// [Document] that holds the lines read from the pubspec.yaml
  late Document document;

  /// attibutes of the pubspec.yaml follow.

  late LineSection name;
  late Version version;
  late MultiLine description;
  late Environment environment;

  late final LineSection homepage;
  late final LineSection repository;
  late final LineSection issueTracker;
  late final LineSection documentation;
  late final Dependencies dependencies;
  late final Dependencies devDependencies;
  late final Dependencies dependencyOverrides;
  late final SimpleSection platforms;
  late final SimpleSection executables;
  late final SimpleSection funding;
  late final SimpleSection falseSecrets;
  late final SimpleSection screenshots;
  late final SimpleSection topics;

  String get loadedFrom =>
      join(_loadedFromDirectory ?? '.', _loadedFromFilename);

  /// Initialises a dependencies section based in the passed [key].
  /// There are three dependencies sections in a pubspec.yaml
  /// * dependencies
  /// * dev_dependencies
  /// * dependency_overrides
  Dependencies _initDependencies(String key) {
    final line = document.findTopLevelKey(key);
    if (line == null) {
      return Dependencies.missing(this, key);
    }

    final dependencies = Dependencies.fromLine(this, line);

    for (final child in line.childrenOf()) {
      if (child.type != LineType.key) {
        continue;
      }
      dependencies.append(Dependency.loadFrom(child), attach: false);
    }
    return dependencies;
  }

  /// Save the pubspec.yaml to [directory].
  void save({String? directory, String? filename}) {
    directory ??= _loadedFromDirectory ?? '.';
    filename ??= _loadedFromFilename ?? join('.', 'pubspec.yaml');

    /// whilst the calls to [render] are ordered (for easy reading)
    /// the underlying lines control the order
    /// that each section is written to disk.
    DocumentWriter(document)
      ..render(name)
      ..render(version)
      ..render(description)
      ..render(environment)
      ..render(homepage)
      ..render(repository)
      ..render(issueTracker)
      ..render(documentation)
      ..render(dependencies)
      ..render(devDependencies)
      ..render(dependencyOverrides)
      ..render(executables)
      ..render(platforms)
      ..render(funding)
      ..render(falseSecrets)
      ..render(screenshots)
      ..render(topics)
      ..renderMissing()
      ..write(directory);
  }

  @override
  String toString() {
    final content = StringBuffer();
    // ignore: prefer_foreach
    for (final line in document.lines) {
      content.writeln(line);
    }
    return content.toString();
  }

  /// search up the directory tree (starting from [directory]to find
  /// a file with the name [filename] which will normally be
  /// pubspec.yaml
  static String _findPubSpecFile(String directory, String filename) {
    var path = join(directory, filename);
    var parent = directory;
    var found = true;
    while (!File(path).existsSync()) {
      if (isRoot(parent)) {
        found = false;
        break;
      }
      parent = dirname(parent);
    }
    path = join(parent, filename);

    if (!found) {
      throw NotFoundException(join(directory, filename));
    }

    return path;
  }

  static bool isRoot(String path) =>
      path.startsWith('/') || path.startsWith(RegExp(r'[a-z]:\\'));
}
