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
/// Libraries should reserve [Level.FINE] for consuming code, preferring
/// [Level.FINER] or [Level.FINEST] for their critical debugging messages.
///
/// "[Silence is golden](http://www.catb.org/esr/writings/taoup/html/ch01s06.html#id2878450)."
library pico_log;

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:pico_log/src/impl.dart';

/// Reflect on [T] to provide its name to the [Logger] constructor.
Logger buildLogger(Type T, {bool useQualifiedName: false}) =>
    new Logger(nameOf(T, !useQualifiedName));

/// Call this early in `main` to configure logging.
/// If [args] contains a flag for `quiet`, `verbose`, `vv`, or `vvv`, the root
/// log level will be `Level.NONE`, `Level.FINE`, `Level.FINER`, `Level.FINEST`,
/// respectively.
///
/// An explicit [level], if provided, will overrides any [args] flags.
void setup(
    {Level level: Level.ALL,
    ArgResults args,
    bool colorize: true,
    bool timestamps: true}) {
  parseLogLevelFlags(args);
  Logger.root.level = level;
  disableColorIfUnsupported();
  Logger.root.onRecord.listen(colorize ? colorized : onData);
  fmt = timestamps ? toMsg : noTimestamps;
}

void parseLogLevelFlags(ArgResults args) {
  if (args.wasParsed('quiet')) Logger.root.level = Level.OFF;
  if (args.wasParsed('verbose')) Logger.root.level = Level.FINE;
  if (args.wasParsed('vv')) Logger.root.level = Level.FINER;
  if (args.wasParsed('vvv')) Logger.root.level = Level.FINEST;
}
