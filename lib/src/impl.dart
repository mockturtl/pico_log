library pico_log.impl;

import 'dart:io';
import 'dart:mirrors';

import 'package:logging/logging.dart';
import 'package:ansicolor/ansicolor.dart';

String nameOf(Type T, bool simple) => simple
    ? _strip(reflectClass(T).simpleName.toString())
    : _strip(reflectClass(T).qualifiedName.toString());

String _strip(String s) => s.substring(s.indexOf('"') + 1, s.lastIndexOf('"'));

typedef String _Stringer(LogRecord);

_Stringer fmt;

void onData(LogRecord rec) {
  var msg = fmt(rec);
  var level = rec.level.name;
  switch (level) {
    default:
      stdout.writeln('$level: $msg');
  }
}

void colorized(LogRecord rec) {
  var msg = fmt(rec);
  var level = rec.level.name;
  switch (level) {
    case 'INFO':
      stdout.writeln(_cyan('$msg'));
      break;
    case 'WARNING':
      stderr.writeln(_yellow('$msg'));
      break;
    case 'SEVERE':
    case 'SHOUT':
      stderr.writeln(_red('$msg'));
      break;
    default:
      stdout.writeln('$msg');
  }
}

_Stringer toMsg = (LogRecord rec) =>
    '${rec.time}: [${rec.loggerName}] ${rec.message}';
_Stringer noTimestamps = (LogRecord rec) =>
    '[${rec.loggerName}] ${rec.message}';

final _cyan = new AnsiPen()..cyan(bold: true);
final _yellow = new AnsiPen()..yellow(bold: true);
final _red = new AnsiPen()..red(bold: true);

void disableColorIfUnsupported() {
  if (!_hasColorSupport) color_disabled = true;
}

// Cribbed from pub.
// https://github.com/dart-lang/pub/blob/6f8ae035883550bfaa690be3aa96f0d2dd8787d7/lib/src/utils.dart#L807
bool get _hasColorSupport => Platform.operatingSystem != 'windows' &&
    stdioType(stdout) == StdioType.TERMINAL;
