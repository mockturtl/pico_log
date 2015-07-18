/// Configures [Logger] behavior.
/// Application code should call [setup] once, early in `main`.
///
///     import 'package:pico_log/pico_log.dart' as pico_log;
///     import 'package:logging/logging.dart';
///
///     final log = new Logger('myapp');
///
///     main() {
///       pico_log.setup();
///       var foo = new Foo(); // Hello, colorful world!
///     }
///
///     class Foo {
///       static final log = pico_log.buildLogger(Foo);
///
///       Foo() {
///         log.info("Hello, colorful world!");
///       }
///     }
///
/// Command-line programs should use [buildArgParser] to provide their logging
/// options.
///
/// Libraries should reserve [Level.FINE] for consuming code, preferring
/// [Level.FINER] or [Level.FINEST] for their critical debugging messages.
///
/// "[Silence is golden](http://www.catb.org/esr/writings/taoup/html/ch01s06.html#id2878450)."
library pico_log;

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:pico_log/src/flags.dart';
import 'package:pico_log/src/impl.dart';

/// Reflect on [T] to provide its name to the [Logger] constructor.
Logger buildLogger(Type T, {bool useQualifiedName: false}) =>
    new Logger(nameOf(T, !useQualifiedName));

/// Call this early in `main` to configure logging.
/// If [args] contains a flag for `silent`, `(q|qq|qqq)uiet`, or `(v|vv|vvv)erbose`,
/// the root log level will be `Level.NONE`, `Level.(WARNING|SEVERE|SHOUT)`,
/// `Level.(FINE|FINER|FINEST)`, respectively.
///
/// An explicit [level], if provided, overrides any [args] flags.
void setup(
    {Level level,
    ArgResults opts,
    bool colorize: true,
    bool timestamps: true}) {
  if (opts != null) {
    parseQuietFlags(opts);
    parseVerboseFlags(opts);
  }
  if (level != null) Logger.root.level = level;
  disableColorIfUnsupported();
  Logger.root.onRecord.listen(colorize ? colorized : onData);
  fmt = timestamps ? toMsg : noTimestamps;
}

/// Understands the following flags:
///
///     - `--silent (-s)`
///     - `--quiet (-q)`, `--qquiet`, `--qqquiet`
///     - `--verbose (-v)`, `--vverbose`, `--vvverbose`
///
/// Note [ArgParser] only allows single-letter short options. For example, `-vvv`
/// is interpreted as `-v`, not `--vvverbose`.
ArgParser buildArgParser() => new ArgParser()
  ..addFlag(Levels.quiet,
      abbr: 'q', help: 'Suppress logger output below WARNING level.')
  ..addFlag(Levels.qq,
      negatable: false, help: 'Suppress logger output below SEVERE level.')
  ..addFlag(Levels.qqq,
      negatable: false, help: 'Suppress logger output below SHOUT level.')
  ..addFlag(Levels.silent,
      abbr: 's', help: 'Suppress all logger output, equivalent to level OFF.')
  ..addFlag(Levels.verbose,
      abbr: 'v', help: 'Show logger output at FINE level.')
  ..addFlag(Levels.vv,
      negatable: false, help: 'Show logger output at FINER level.')
  ..addFlag(Levels.vvv,
      negatable: false, help: 'Show logger output at FINEST level.');
