/// [LogInit] configures [Logger] behavior.
/// Application code should call [setup] once, early in [main].
///
///     import 'package:pico_log/pico_log.dart' as pico_log;
///     import 'package:logging/logging.dart';
///
///     final log = new Logger('myapp');
///
///     main() {
///       pico_log.setup();
///       var foo = new Foo(); // Hello, world!
///       // ...
///     }
///
///     class Foo {
///       static final log = buildLogger(Foo);
///
///       Foo() {
///         log.info("Hello, world!");
///       }
///     }
///
/// Libraries should reserve [Level.FINE] for consuming code,
/// preferring [Level.FINER] or [Level.FINEST] for their critical debugging messages.
/// "[Silence is golden](http://www.catb.org/esr/writings/taoup/html/ch01s06.html#id2878450)."

library pico_log;

import 'package:logging/logging.dart';
import 'package:pico_log/src/impl.dart';

/// Reflect on [T] to provide its name to the [Logger] constructor.
Logger buildLogger(Type T, {bool useQualifiedName: false}) =>
    new Logger(nameOf(T, !useQualifiedName));

/// Call this early in `main` to configure logging.
void setup(
    {Level level: Level.ALL, bool colorize: true, bool timestamps: true}) {
  Logger.root.level = level;
  // TODO: prefer ansicolor's color_disabled flag
  // TODO: check for color support https://code.google.com/p/dart/issues/detail?id=15304
  Logger.root.onRecord.listen(colorize ? colorized : onData);
  fmt = timestamps ? toMsg : noTimestamps;
}
