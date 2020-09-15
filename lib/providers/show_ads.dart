import 'package:flutter/foundation.dart';

class ShowAds with ChangeNotifier {
  int _count = 0;

  int get count {
    return _count;
  }

  final bool _isAdsEnable = true;

  void increseCounter() {
    if (_isAdsEnable) {
      if (_count <= 2) {
        _count++;
      } else {
        _count = 0;
      }
      notifyListeners();
    }
  }
}
