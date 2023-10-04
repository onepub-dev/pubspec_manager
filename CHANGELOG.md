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
