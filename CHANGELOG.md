# 1.0.3
- Widen `strings` dependency range to include `4.0.0` release (no breaking changes).

# 1.0.2
- Fixed a parsing bug. If there was no version for the pubspec we would grab the version from the first dependency. We now only look for a version at the top level.
- Fixed #17 - a comment line that appeared after the name of a depencency
  for a hosted package would cause the parser to fail.

# 1.0.1
- Merge pull request #15 from Azramis/main
- Add unit tests for git deps usage
- Fixed Git dependencies usage

# 1.0.0
- originally released as 0.9.0 as we are missing a few features, but the dart pub resolution
keeps telling people to upgrade to the 1.x beta (which is actually older) so
I need to change to 1.0.0 to keep things sane.
No other changes have been made.
# 0.9.1
- corrected the name of DependencyAltHostedBuilder as it should be DependencyBuilderAltHosted.

# 0.9.0
- released with a few, low use,  missing keys. a good release is better than perfection with no release.

# 1.0.0-beta.1
- relased first beta.

# 1.0.0-alpha.17
- changed publishTo.set to value - not certain this is consistent. executables.append no directly takes a name rather than requiring a builder.
- renamed Platform to PlatformSupport to avoid a conflict with the dart core Platform class.
- implemented value and set for version.
- added additional examples to the readme.
- fixed the processing of multi-line strings - essentially the description field.
- made version and environment sections and dealt with the fall out. renamed section.line to section.sectionHeading to make its use more obvious.
- added specific description class
- added update example to README.md
- added an example on how to update the version no.

# 1.0.0-alpha.16
- Fixed a bug in the iterator for dependencies, exectuables and platforms.

# 1.0.0-alpha.15
- updated tests and example in line with api changes.
- change getVersion and setVersion to getSemVersion and setSemVersion to make their nature more apparent.
- renaned the environmentBuilder arg to PubSpec to environment in keeping with the naming pattern elsewhere.
- Fixed a number of the setters for pubspec keys.
- removed the need to pass the key to the versionbuider as it is known by the builder.
- added publishTo key.
- Fixed a bug where the section for a dependency wasn't being created correctly as we created it before all of the dependencies' lines had been added to the document.

# 1.0.0-alpha.14
- Fixed a formatting issue where inline comments didn't preserve leading whitespace. We now do.
- Fixed a bug where a comment after a dep was being associated with two sections.

# 1.0.0-alpha.13
- Fixes: #3 when loading a pubspec an an exception was thrown we reported that the pubspec was being loaded from a string even when it was loaded from a file.

# 1.0.0-alpha.12
- BREAKING dependency classes have been renamed to begin with Dependency
so PubHostedDependency becomes DependencyPubHosted. This is to help with discovery and auto-completion.
- HostedDependency is now called DependencyAltHosted

# 1.0.0-alpha.11
- Fixes for environment when the sdk or flutter constraints where missing.
- work on validating the function of the VersionConstraint class

# 1.0.0-alpha.10
- Fixed a bug in the version_constraint. It wasn't being updated correctly when a new value was assigned to it.

# 1.0.0-alpha.9
- lint cleanup
- Change insert to InsertBefore to avoid line maths being done all over the place. Now you just pass the nearest line and we insert relative to that. Added helper functions to make the indent consistent.
- renamed the base section to builders and removed the 'attached' component of the section names;

# 1.0.0-alpha.8
- fixed a bug in Line.text where the text value wasn't being updated if the key or value of the line where changed.
- additional test cases.
- line_section now implements rather than extends line.
- Added toString method to key_value
- added platform specific line terminator when writting pubspec.
- changed the pubspec render process to use a writer interface so we can switch out the render target.
- Fixed bugs in executables when trying to append or update an executable.
- imporved the readme example.
- Fixed a bug in ExectuableAttached which prevented changing of the executable name. Fixed a bug in the scriptPath. When there was no script we returned .dart rather than name.dart.

# 1.0.0-alpha.6
- renamed Pubspec to PubSpec. 
- Fixed a bug when setting the flutter and sdk environments. 
- Added logic to track if versions where quoted so we can preserve the quoting.
- general cleanup nd bug fixes.

# 1.0.0-alpha.5
- Cleaner demarkation between attached and non-attached entities.
- you can now provide a documentation url and associate comments with it.

# 1.0.0-alpha.3
- rework of api to make creation more fluid that is close to be declarative
- add support for additional pubspec keys.
- add wrappers for more keys such as Executables to make interaction more
  intuitive as we now expose specific property names such as 'url' rather than 'value'.
- Split every dep into a dep and a dep attached so we didn't have to
deal with nulls and the user had a cleaner view of the public apis.
# 1.0.0-alpha.2
- core functions are working - you can read/write a pubspec and make basic mods.
- working on decluttering the public API.
- added functioning example
- the parsing of the description as a yaml scalar is only working for some scalar types (simple and single quoted)

# 1.0.0-alpha.1
- Initial pre-release
