import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/question_type.dart';

import '../helpers/db.dart';

class QuestionData {
  final int id;
  final List<Map<String, dynamic>> answers;
  final String situation;
  final String explanation;

  QuestionData({
    @required this.id,
    @required this.explanation,
    @required this.situation,
    this.answers,
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
          ? "http://68.183.71.76:8000/question?category=$categoryId"
          : "http://68.183.71.76:8000/question",
    );
    final data = json.decode(utf8.decode(response.bodyBytes));
    _activeQuestion = QuestionData(
      id: data['id'],
      situation: data['situation'],
      explanation: data['explanation'],
      answers: [
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
    notifyListeners();
  }

  Future saveCurrentQuestionLocally() async {
    await DB.insert(
      'user_fav',
      {
        'id': _activeQuestion.id,
        'situation': _activeQuestion.situation,
        'explanation': _activeQuestion.explanation,
      },
    );
  }

  Future<List<QuestionData>> getLocallySavedQuestion() async {
    final dataList = await DB.getData('user_fav');
    return dataList
        .map((e) => QuestionData(
              id: e['id'],
              situation: e['situation'],
              explanation: e['explanation'],
            ))
        .toList();
  }
}
