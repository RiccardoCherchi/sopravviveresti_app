import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/question_type.dart';

class QuestionData {
  final List<Map<String, dynamic>> questions;
  final String situation;
  final String explanation;

  QuestionData({
    @required this.questions,
    @required this.explanation,
    @required this.situation,
  });
}

class Questions with ChangeNotifier {
  QuestionData _activeQuestion;

  QuestionData get activeQuestion {
    return _activeQuestion;
  }

  Future getNewQuestion([int categoryId]) async {
    final response = await http.get(
      categoryId != null
          ? "http://192.168.0.103:8000/question?category=$categoryId"
          : "http://192.168.0.103:8000/question",
    );
    final data = json.decode(utf8.decode(response.bodyBytes));
    print(data);
    _activeQuestion = QuestionData(
      situation: data['situation'],
      explanation: data['explanation'],
      questions: [
        {
          "content": data['correct_answer'],
          "type": QuestionType.correct,
        },
        {
          "content": data['wrong_answer'],
          "type": QuestionType.wrong,
        }
      ]..shuffle(),
    );
    print(_activeQuestion.questions);
    notifyListeners();
  }
}
