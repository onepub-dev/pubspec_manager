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
