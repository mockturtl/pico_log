library pico_log.flags;

import 'package:args/args.dart';
import 'package:logging/logging.dart';

class Levels {
  static const quiet = 'quiet';
  static const qq = 'qquiet';
  static const qqq = 'qqquiet';
  static const silent = 'silent';
  static const verbose = 'verbose';
  static const vv = 'vverbose';
  static const vvv = 'vvverbose';
}

void parseQuietFlags(ArgResults opts) {
  if (_understands(opts, Levels.silent)) {
    if (opts[Levels.silent]) Logger.root.level = Level.OFF;
    if (_isExplicitlyNegated(opts,
        Levels.silent)) return _reset(); // bail out of parsing quiet modes
  }

  if (_understands(opts, Levels.quiet)) {
    if (opts[Levels.quiet]) Logger.root.level = Level.WARNING;
    if (_isExplicitlyNegated(opts,
        Levels.quiet)) return _reset(); // bail out of parsing -qq, -qqq modes
  }

  if (_isTrue(opts, Levels.qq)) Logger.root.level = Level.SEVERE;
  if (_isTrue(opts, Levels.qqq)) Logger.root.level = Level.SHOUT;
}

void parseVerboseFlags(ArgResults opts) {
  if (_understands(opts, Levels.verbose)) {
    if (opts[Levels.verbose]) Logger.root.level = Level.FINE;
    if (_isExplicitlyNegated(opts,
        Levels.verbose)) return _reset(); // bail out of parsing -vv, -vvv modes
  }

  if (_isTrue(opts, Levels.vv)) Logger.root.level = Level.FINER;
  if (_isTrue(opts, Levels.vvv)) Logger.root.level = Level.FINEST;
}

/// The parser assigns negated flags (`--no-opt`) the value `false`.
/// Treat them differently from those which have default value `false`.
bool _isExplicitlyNegated(ArgResults opts, String longName) =>
    opts.wasParsed(longName) && !opts[longName];

void _reset() {
  Logger.root.level = Level.INFO;
}

bool _isTrue(opts, String opt) => _understands(opts, opt) && opts[opt];
bool _understands(ArgResults opts, String opt) => opts.options.contains(opt);
