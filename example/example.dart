library example;

import 'package:logging/logging.dart';
import 'package:pico_log/pico_log.dart';

var f = new Foo();

main() {
  LogInit.setup(colorize: false);
  f.demo();
}

class Foo {

  static final Logger log = new Logger('Foo');

  void demo() {
    log.fine('Hello world!');
    log.info('Attention world!');
    log.warning('Warning, world!');
    log.severe('Severe, world!!');
    log.shout('SHOUTING, WORLD!!!1');
  }

}