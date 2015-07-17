library pico_log.flags;

import 'package:args/args.dart';
import 'package:logging/logging.dart';

const _quiet = 'quiet';
const _qq = 'qquiet';
const _qqq = 'qqquiet';
const _silent = 'silent';
const _verbose = 'verbose';
const _vv = 'vverbose';
const _vvv = 'vvverbose';

void parseQuietFlags(ArgResults opts) {
  if (_understands(opts, _silent)) {
    if (opts[_silent]) Logger.root.level = Level.OFF;
    if (_isExplicitlyNegated(
        opts, _silent)) return _reset(); // bail out of parsing quiet modes
  }

  if (_understands(opts, _quiet)) {
    if (opts[_quiet]) Logger.root.level = Level.WARNING;
    if (_isExplicitlyNegated(
        opts, _quiet)) return _reset(); // bail out of parsing -qq, -qqq modes
  }

  if (_isTrue(opts, _qq)) Logger.root.level = Level.SEVERE;
  if (_isTrue(opts, _qqq)) Logger.root.level = Level.SHOUT;
}

void parseVerboseFlags(ArgResults opts) {
  if (_understands(opts, _verbose)) {
    if (opts[_verbose]) Logger.root.level = Level.FINE;
    if (_isExplicitlyNegated(
        opts, _verbose)) return _reset(); // bail out of parsing -vv, -vvv modes
  }

  if (_isTrue(opts, _vv)) Logger.root.level = Level.FINER;
  if (_isTrue(opts, _vvv)) Logger.root.level = Level.FINEST;
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
