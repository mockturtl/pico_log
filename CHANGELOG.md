changelog
=========

This project follows [pub-flavored semantic versioning][pub-semver]. ([more][pub-semver-readme])

Release notes are available on [github][notes].

[pub-semver]: https://www.dartlang.org/tools/pub/versioning.html#semantic-versions
[pub-semver-readme]: https://pub.dartlang.org/packages/pub_semver
[notes]: https://github.com/mockturtl/pico_log/releases

#### 0.3.1+1

- [fix] use `stderr` when output is not colorized

0.3.1
-----

- [feat] provide default parser for command-line flags

0.3.0
-----

- [fix] handle undefined flags
- [feat] add flags for `silent`, `(qq|qqq)iet`, `(vv|vvv)erbose`

0.2.1
-----

- [feat] accept parsed command-line options for `quiet`, `verbose`
- [deps] args @ 0.13

0.2.0
-----

- [feat] detect support for ANSI color output
- [deps] logging -> `^0.11`

0.1.0
-----

Initial release.
