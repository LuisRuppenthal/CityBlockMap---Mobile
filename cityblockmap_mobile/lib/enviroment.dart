import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Environment {
  static String get apiUrl {
    if (kIsWeb) return 'http://127.0.0.1:8080';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://127.0.0.1:8080';
  }
}
