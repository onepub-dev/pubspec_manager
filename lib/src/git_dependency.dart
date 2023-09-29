part of 'internal_parts.dart';

/// Git style dependency.
class GitDependency implements Dependency {
  GitDependency(String name, {String? url, String? ref, String? path})
      : _name = name,
        details = GitDetails(url: url, ref: ref, path: path);

  GitDependency._fromDetails(this._name, this.details);

  static const key = 'git';

  final String _name;

  @override
  String get name => _name;

  GitDetails details;

  @override
  Version get version => Version.empty();

  @override
  DependencyAttached _attach(Pubspec pubspec, int lineNo) =>
      GitDependencyAttached._attach(pubspec, lineNo, this);
}

/// Holds the details of a git dependency.
class GitDetails {
  GitDetails({this.url, this.ref, this.path});

  GitDetails.fromLine(Line line)
      : urlLine = line.findKeyChild('url'),
        refLine = line.findKeyChild('ref'),
        pathLine = line.findKeyChild('path') {
    path = pathLine?.value;
    ref = refLine?.value;
    url = urlLine?.value;
  }

  String? url;
  String? ref;
  String? path;

  Line? urlLine;
  Line? refLine;
  Line? pathLine;

  List<Line> get lines => [
        if (urlLine != null) urlLine!,
        if (refLine != null) refLine!,
        if (pathLine != null) pathLine!
      ];

  // void _attach(Pubspec pubspec, int lineNo) {
  //   if (_attachLine(pubspec, lineNo, key: 'url', value: url)) {
  //     lineNo++;
  //   }
  //   if (_attachLine(pubspec, lineNo, key: 'url', value: url)) {
  //     lineNo++;
  //   }
  //   if (_attachLine(pubspec, lineNo, key: 'url', value: url)) {
  //     lineNo++;
  //   }
  // }

  // bool _attachLine(Pubspec pubspec, int lineNo,
  //     {required String key, required String? value}) {
  //   var attached = false;
  //   if (value != null) {
  //     final _line = Line.forInsertion(pubspec.document, '    $key: $value');
  //     pubspec.document.insert(_line, lineNo);
  //     attached = true;
  //   }
  //   return attached;
  // }
}
