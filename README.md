pico_log
========

Configure `Logger` behavior in one line.

usage
-----

Application code must call `LogInit.setup()` once, early in `main`.

```dart
import 'package:pico_log/pico_log.dart';
import 'package:logging/logging.dart';

final _log = new Logger('myapp');

void main() {
  LogInit.setup();
  _log.info("hello, world!");
  // ...
}
```
