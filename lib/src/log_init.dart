part of pico_log;

/// [LogInit] configures [Logger] behavior.
/// Application code should call [setup] once, early in [main].
///
/// Libraries should reserve [Level.FINE] for consuming code,
/// preferring [Level.FINER] or [Level.FINEST] for their debugging messages.
class LogInit {
  static Function _fmt;

  /// Call this early in [main] to configure logging.
  static void setup(
      {Level level: Level.ALL, bool colorize: true, bool timestamps: true}) {
    Logger.root.level = level;
    // TODO: prefer ansicolor's color_disabled flag
    // TODO: check for color support https://code.google.com/p/dart/issues/detail?id=15304
    Logger.root.onRecord.listen(colorize ? _colorize : _onData);
    _fmt = timestamps ? _toMsg : _noTimestamps;
  }

  // TODO: stdio

  static void _onData(LogRecord rec) {
    var msg = _fmt(rec);
    var level = rec.level.name;
    switch (level) {
      default:
        print('$level: $msg');
    }
  }

  static void _colorize(LogRecord rec) {
    var msg = _fmt(rec);
    var level = rec.level.name;
    switch (level) {
      case 'INFO':
        print(cyan('$msg'));
        break;
      case 'WARNING':
        print(yellow('$msg'));
        break;
      case 'SEVERE':
      case 'SHOUT':
        print(red('$msg'));
        break;
      default:
        print('$msg');
    }
  }

  static String _toMsg(LogRecord rec) =>
      '${rec.time}: [${rec.loggerName}] ${rec.message}';
  static String _noTimestamps(LogRecord rec) =>
      '[${rec.loggerName}] ${rec.message}';

  static final cyan = new AnsiPen()..cyan(bold: true);
  static final yellow = new AnsiPen()..yellow(bold: true);
  static final red = new AnsiPen()..red(bold: true);
}
