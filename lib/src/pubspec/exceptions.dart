part of 'internal_parts.dart';

/// All exceptions throw from this package are based
/// on this exception.
class PubSpecException implements Exception {
  PubSpecException(this.line, this.message) {
    document = line?._document;
  }
  PubSpecException.forDocument(this.document, this.message);

  PubSpecException.global(this.message);

  String message;
  Line? line;
  Document? document;

  @override
  String toString() {
    final error = StringBuffer();

    if (document != null) {
      error.write('''
Pubspec: ${document!.pathTo}
''');
    }

    if (line != null) {
      error.write('''
Line No.: ${line!.lineNo} 
Line Type: ${line!.lineType.name}
Section Indent: ${line!.indent} 
Line Content: ${Strings.orElse(line!.text, "<empty>")}
''');
    }
    error.write('Error: $message');
    return error.toString();
  }
}

/// Thrown when the pubspec file can't be found.
class NotFoundException extends PubSpecException {
  NotFoundException(super.message) : super.global();
}

/// Thrown when an invalid version is passed.
class VersionException extends PubSpecException {
  VersionException(super.message) : super.global();
}

/// Thrown when you try to access a dependency by name
/// and that dependency doesn't exist.
class DependencyNotFound extends PubSpecException {
  DependencyNotFound(Document super.document, super.message)
      : super.forDocument();
}

/// Thrown when you try to access an executable by name
/// and that executable doesn't exist.
class ExecutableNotFound extends PubSpecException {
  ExecutableNotFound(Document super.document, super.message)
      : super.forDocument();
}

/// Thrown when you try to access a platform by name
/// and that platform doesn't exist.
class PlatformNotFound extends PubSpecException {
  PlatformNotFound(Document super.document, super.message)
      : super.forDocument();
}

class OutOfBoundsException extends PubSpecException {
  OutOfBoundsException(super.line, super.message);
}

class DuplicateKeyException extends PubSpecException {
  DuplicateKeyException(super.line, super.message);
}

// /// Don't use this exception directly (its abstract).
// /// Instead use one of the more specific derived exceptions or create
// /// your own extending from this exception.
// abstract class CommandLineException extends DCliException {
//   ///
//   CommandLineException(super.message);
// }

// /// Thrown when an invalid argument is passed to a command.
// class InvalidCommandArgumentException extends CommandLineException {
//   ///
//   InvalidCommandArgumentException(super.message);
// }
