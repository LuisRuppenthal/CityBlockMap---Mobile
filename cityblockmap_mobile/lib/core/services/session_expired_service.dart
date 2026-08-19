import 'package:flutter/foundation.dart';

class SessionExpiredService extends ChangeNotifier {
  SessionExpiredService._internal();
  static final SessionExpiredService instance =
      SessionExpiredService._internal();

  bool _visible = false;
  bool get visible => _visible;

  void show() {
    _visible = true;
    notifyListeners();
  }

  void hide() {
    _visible = false;
    notifyListeners();
  }
}
