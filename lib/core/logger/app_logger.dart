
import 'package:logger/logger.dart';
import 'package:tupay/core/logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: SimpleLogPrinter(),
  );

  // Global logging function
  static void log(dynamic message, {Level level = Level.info}) {
    switch (level) {
      case Level.debug:
        _logger.d(message);
        return;
      case Level.info:
        _logger.i(message);
        return;
      case Level.warning:
        _logger.w(message);
        return;
      case Level.error:
        _logger.e(message);
        return;
      case Level.trace:
        _logger.t(message);
        return;
      case Level.fatal:
        _logger.f(message);
        return;
      case Level.all:
      case Level.verbose:
      case Level.wtf:
      case Level.nothing:
      case Level.off:
      // Handle unused log levels gracefully
        _logger.w('Unused log level called: $level');
        return;
    }
  }

  // Shortcut for debugging
  static void d(dynamic message) => log(message, level: Level.debug);

  // Shortcut for informational messages
  static void i(dynamic message) => log(message);

  // Shortcut for warnings
  static void w(dynamic message) => log(message, level: Level.warning);

  // Shortcut for errors
  static void e(dynamic message) => log(message, level: Level.error);

  // Shortcut for verbose/trace
  static void v(dynamic message) => log(message, level: Level.trace);

  // Shortcut for critical/WTF-level messages
  static void wtf(dynamic message) => log(message, level: Level.fatal);
}
