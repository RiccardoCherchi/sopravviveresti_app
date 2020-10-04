import 'dart:async';

import 'package:flutter/foundation.dart';

import '../helpers/db.dart';

class Hearts with ChangeNotifier {
  int _hearts;

  int get hearts {
    return _hearts;
  }

  Future getHearts() async {
    final List data = await DB.getData("hearts");
    _hearts = data[0]['amount'];
    notifyListeners();
  }

  Future removeHeart() async {
    await DB.updateById('hearts', 1, {
      "id": 1,
      "amount": _hearts - 1,
    });
    await getHearts();
    notifyListeners();
  }

  Future addHearts(int amount) async {
    if (_hearts == 0) {
      await DB.updateById('hearts', 1, {
        "id": 1,
        "amount": _hearts + amount,
      });
    }
    await getHearts();
    notifyListeners();
  }

  Future getTimeLeftForGeneration() async {
    await getHearts();
    final data = await DB.getData("hearts_time");

    final endDate = data[0]['date'];

    Duration timeLeft =
        DateTime.parse(endDate).difference(DateTime.now().toUtc());

    if (timeLeft.isNegative) {
      timeLeft = timeLeft - Duration(seconds: timeLeft.inSeconds * 2);
    } else {
      return timeLeft;
    }

    final difference = timeLeft - Duration(hours: 24);

    Duration finalTimeLeft = Duration(hours: 24) - difference;

    if (finalTimeLeft.isNegative) {
      finalTimeLeft = Duration(hours: 24) + finalTimeLeft;
    }

    final heartsToAdd = 3;

    print("hearts to add: $heartsToAdd");

    print("final time left: $finalTimeLeft");

    if (_hearts == 0) {
      print("adding $heartsToAdd hearts...");
      final resetTime = DateTime.now().toUtc().add(finalTimeLeft);
      print("reset time left: $resetTime");

      await addHearts(heartsToAdd);
      await resetDate(resetTime);
    }

    return finalTimeLeft;
  }

  Future resetDate([DateTime customDate]) async {
    DateTime date = DateTime.now().toUtc().add(Duration(days: 1));

    if (customDate != null) {
      date = customDate;
    }

    await DB.updateById("hearts_time", 1, {
      "id": 1,
      "date": date.toIso8601String(),
    });
  }

  // debug
  Future changeTime() async {
    final date = DateTime.now().toUtc().add(Duration(seconds: 5));
    print("test date: $date");

    await DB.updateById("hearts_time", 1, {
      "id": 1,
      "date": date.toIso8601String(),
    });
  }
}
