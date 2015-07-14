library example;

import 'package:pico_log/pico_log.dart' as pico_log;

var f = new Foo();
var b = new Bar();

main() {
  pico_log.setup();
  f.demo();
  b.demo();
}

class Foo {
  static final log = pico_log.buildLogger(Foo);

  void demo() {
    log.fine('Hello world!');
    log.info('Attention world!');
    log.warning('Warning, world!');
    log.severe('Severe, world!!');
    log.shout('SHOUTING, WORLD!!!1');
  }
}

class Bar {
  static final log = pico_log.buildLogger(Bar, useQualifiedName: true);

  void demo() {
    log.fine('Hello world!');
    log.info('Attention world!');
    log.warning('Warning, world!');
    log.severe('Severe, world!!');
    log.shout('SHOUTING, WORLD!!!1');
  }
}
