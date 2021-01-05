import 'package:flutter/foundation.dart';

import '../models/question_type.dart';
import '../models/game_type.dart';

import '../helpers/db.dart';

import '../helpers/api.dart';

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

  int _quizIndex = 0;
  int _quizLength = 0;
  int _currentQuizId;

  int _correctQuizAnswers = 0;

  int _lastCategoryId;

  int get lastCategoryId {
    return _lastCategoryId;
  }

  int get currentQuizId {
    return _currentQuizId;
  }

  int get quizLength {
    return _quizLength;
  }

  int get quizIndex {
    return _quizIndex;
  }

  int get correctQuizAnswers {
    return _correctQuizAnswers;
  }

  set setCorrectQuizAnswers(int value) {
    print(value);
    _correctQuizAnswers = value;
  }

  void deleteLastCategoryId() {
    _lastCategoryId = null;
  }

  QuestionData get activeQuestion {
    return _activeQuestion;
  }

  void resetQuizIndex() {
    _quizIndex = 0;
    print("quiz index was resetted: $_quizIndex");
    notifyListeners();
  }

  String _getUrl(GameType gameType, {int categoryId}) {
    if (gameType == GameType.classic) {
      String url = "/question?";
      if (categoryId != null) {
        return "${url}category=$categoryId";
      } else {
        return url;
      }
    } else {
      return "/general-culture/question";
    }
  }

  Future getQuizQuestion(int quizId) async {
    final response = await api.get(
      path: "/quiz/question?quiz_id=$quizId",
    );
    final List data = response.data;

    final List<QuestionData> quizQuestions = data
        .map((e) => QuestionData(
            explanation: e['explanation'],
            id: e['id'],
            situation: e['situation'],
            answers: (e['answers'] as List).map((e) {
              return {
                "content": e['text'],
                "type": (e['is_correct'] as bool)
                    ? QuestionType.correct
                    : QuestionType.wrong,
              };
            }).toList()))
        .toList();

    _quizLength = quizQuestions.length;
    _currentQuizId = quizId;

    // randomize
    final active = quizQuestions[_quizIndex];
    active.answers..shuffle();

    print("active quiz question: ${active.id}");

    _activeQuestion = quizQuestions[_quizIndex];
    _quizIndex++;

    notifyListeners();
  }

  Future getNewQuestion(
      {int categoryId, int quizId, @required GameType gameType}) async {
    if (categoryId != null) {
      _lastCategoryId = categoryId;
    }
    String url = _getUrl(gameType, categoryId: categoryId);

    final response = await api.get(path: url);

    final data = response.data;

    List<Map<String, dynamic>> _getAnwers() {
      if (gameType == GameType.general_question) {
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
  // local

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
