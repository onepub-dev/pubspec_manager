library internal;

import 'dart:collection';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:pub_semver/pub_semver.dart' as sm;
import 'package:strings/strings.dart';

import 'document/document.dart';
import 'document/document_writer.dart';
import 'document/line.dart';
import 'document/line_detached.dart';
import 'document/line_section.dart';
import 'document/line_type.dart';
import 'document/multi_line.dart';
import 'document/section.dart';
import 'document/section_single_line.dart';
import 'document/simple_section.dart';

part 'comments_attached.dart';
part 'dependencies.dart';
part 'dependency.dart';
part 'dependency_attached.dart';
part 'documentation.dart';
part 'environment.dart';
part 'environment_attached.dart';
part 'exceptions.dart';
part 'executable.dart';
part 'executables.dart';
part 'git_dependency.dart';
part 'git_dependency_attached.dart';
part 'homepage.dart';
part 'hosted_dependency.dart';
part 'hosted_dependency_attached.dart';
part 'issue_tracker.dart';
part 'path_dependency.dart';
part 'path_dependency_attached.dart';
part 'pub_hosted_dependency.dart';
part 'pub_hosted_dependency_attached.dart';
part 'pubspec.dart';
part 'repository.dart';
part 'version.dart';
part 'version_attached.dart';
