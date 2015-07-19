library example;

import 'package:pico_log/pico_log.dart';

var f = new Foo();
var b = new Bar();

main() {
  setup(); // default log level is INFO
  f.demo();
  b.demo();
}

class Foo {
  static final log = buildLogger(Foo);

  void demo() {
    log.fine('Hello world!');
    log.info('Attention world!');
    log.warning('Warning, world!');
    log.severe('Severe, world!!');
    log.shout('SHOUTING, WORLD!!!1');
  }
}

class Bar {
  static final log = buildLogger(Bar, useQualifiedName: true);

  void demo() {
    log.fine('Hello world!');
    log.info('Attention world!');
    log.warning('Warning, world!');
    log.severe('Severe, world!!');
    log.shout('SHOUTING, WORLD!!!1');
  }
}
