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

  int _lastCategoryId;

  int get lastCategoryId {
    return _lastCategoryId;
  }

  QuestionData get activeQuestion {
    return _activeQuestion;
  }

  Future getNewQuestion(
      {int categoryId, bool isGeneralCuluture = false}) async {
    if (categoryId != null) {
      _lastCategoryId = categoryId;
    }
    final String url = categoryId != null
        ? "http://68.183.71.76:8000/question?category=$categoryId"
        : isGeneralCuluture
            ? "http://68.183.71.76:8000/general-culture/question"
            : "http://68.183.71.76:8000/question";
    final response = await http.get(url);
    final data = json.decode(utf8.decode(response.bodyBytes));

    List<Map<String, dynamic>> _getAnwers() {
      if (isGeneralCuluture) {
        return (data['answers'] as List).map((e) {
          return {
            "content": e['text'],
            "type": (e['is_correct'] as bool)
                ? QuestionType.correct
                : QuestionType.wrong,
          };
        }).toList();
      } else {
        return [
          {
            "content": data['correct_answer'],
            "type": QuestionType.correct,
          },
          {
            "content": data['wrong_answer'],
            "type": QuestionType.wrong,
          }
        ];
      }
    }

    _activeQuestion = QuestionData(
      id: data['id'],
      situation: data['situation'],
      explanation: data['explanation'],
      answers: _getAnwers()..shuffle(),
    );
    notifyListeners();
  }

  Future getNewQuestionWithLastCategory() async {
    await getNewQuestion(categoryId: _lastCategoryId);
    notifyListeners();
  }

  // locally

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

  Future deleteLocallySavedQuestion(int id) async {
    await DB.delete('user_fav', id);
  }

  Future checkSavedQuestion(int id) async {
    final List test = await DB.filterById('user_fav', id);
    return test.length > 0;
  }
}
