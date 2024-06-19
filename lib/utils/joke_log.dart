import 'package:logger/logger.dart';

class JokeLog {
  static final _logger = Logger();

  static t(String msg) {
    _logger.t(msg);
  }

  static d(String msg) {
    _logger.d(msg);
  }

  static i(String msg) {
    _logger.i(msg);
  }

  static w(String msg) {
    _logger.w(msg);
  }

  static e(String msg) {
    _logger.e(msg);
  }

  static f(String msg) {
    _logger.f(msg);
  }

}

