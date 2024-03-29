library internal;

import 'dart:convert';
import 'dart:io' as io;

import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:pub_semver/pub_semver.dart' as sm;
import 'package:strings/strings.dart';

import '../document/key_value.dart';
import 'dependency_versioned.dart';

part '../document/document.dart';
part '../document/document_writer.dart';
part '../document/line.dart';
part '../document/line_detached.dart';
part '../document/line_impl.dart';
part '../document/line_section.dart';
part '../document/line_type.dart';
part '../document/multi_line.dart';
part '../document/section.dart';
part '../document/section_impl.dart';
part '../document/section_single_line.dart';
part 'comments.dart';
part 'dependencies.dart';
part 'dependency.dart';
part 'dependency_alt_hosted.dart';
part 'dependency_builder_alt_hosted.dart';
part 'dependency_builder.dart';
part 'dependency_builder_git.dart';
part 'dependency_builder_path.dart';
part 'dependency_builder_pub_hosted.dart';
part 'dependency_builder_sdk.dart';
part 'dependency_git.dart';
part 'dependency_mixin.dart';
part 'dependency_path.dart';
part 'dependency_pub_hosted.dart';
part 'dependency_sdk.dart';
part 'description.dart';
part 'documentation.dart';
part 'environment.dart';
part 'environment_builder.dart';
part 'exceptions.dart';
part 'executable.dart';
part 'executable_builder.dart';
part 'executables.dart';
part 'homepage.dart';
part 'issue_tracker.dart';
part 'name.dart';
part 'platform_support.dart';
part 'platforms.dart';
part 'publish_to.dart';
part 'pubspec.dart';
part 'repository.dart';
part 'version.dart';
part 'version_constraint.dart';
part 'version_constraint_builder.dart';
