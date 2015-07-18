import 'package:pico_log/src/impl.dart';
import 'package:test/test.dart';

import 'src/fixtures.dart';

main() {
  group('[pico_log.impl]', () {
    test('nameOf', () {
      expect(nameOf(Foo, true), equals('Foo'));
      expect(nameOf(Foo, false), equals('pico_log.test.fixtures.Foo'));
    });
  });
}
