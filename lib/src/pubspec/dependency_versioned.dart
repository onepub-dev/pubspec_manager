/// Some dependency define a package version number
/// Dependencies that do so must implement this interface.
abstract class DependencyVersioned {
  set versionConstraint(String version);
  String get versionConstraint;
}
