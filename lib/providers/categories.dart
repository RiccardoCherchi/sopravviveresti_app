import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../helpers/api.dart';

class Category {
  final int id;
  final String name;

  Category(
    this.id,
    this.name,
  );

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class Quiz {
  final int id;
  final int pack_id;
  final String name;
  final String imageUrl;
  final String priceKey;
  final int questionsLength;
  bool isPremium;

  Quiz(
    this.id,
    this.imageUrl,
    this.priceKey,
    this.name,
    this.isPremium,
    this.questionsLength,
    this.pack_id,
  );

  Quiz.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imageUrl = json['image'],
        priceKey = json['key'],
        isPremium = json['is_premium'],
        pack_id = json['pack_id'],
        questionsLength = json['questions_length'];
}

class QuizPack {
  final int id;
  final String name;
  final String priceKey;
  final double price;
  final List<Quiz> quizzes;

  QuizPack(this.name, this.id, this.priceKey, this.price, [this.quizzes]);

  QuizPack.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        priceKey = json['key'],
        price = json['price'],
        quizzes = json['quizzes'] == null
            ? null
            : (json['quizzes'] as List).map((e) => Quiz.fromJson(e)).toList();
}

class Categories with ChangeNotifier {
  List<Category> _categories;
  List<Quiz> _quizzes;

  List<Category> get categories {
    return [..._categories];
  }

  List<Quiz> get quizzes {
    return [..._quizzes];
  }

  Future getCategoires(
      {bool isQuiz = false, bool isGeneralCulture = false}) async {
    try {
      String url = isQuiz
          ? "/quiz"
          : isGeneralCulture
              ? "/general-culture/categories"
              : "/categories";

      final response = await api.get(path: url);
      final data = response.data;
      List<Category> _loadedCateogires = [];
      List<Quiz> _loadedQuizzes = [];
      data.forEach((e) {
        if (isQuiz) {
          _loadedQuizzes.add(Quiz.fromJson(e));
        } else {
          _loadedCateogires.add(Category.fromJson(e));
        }
      });
      _categories = _loadedCateogires;
      _quizzes = _loadedQuizzes;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<List> getPacks() async {
    final response = await api.get(path: "/quiz/pack");
    final data = response.data;

    if (response.statusCode != 404) {
      List<QuizPack> _packs = [];
      data.forEach((e) {
        _packs.add(QuizPack.fromJson(e));
      });
      return _packs;
    }
    return List.empty();
  }

  Future getPackByQuiz(int quizId) async {
    final response = await api.get(path: "/quiz/$quizId/pack");
    final data = response.data;

    final quizPack = QuizPack.fromJson(data);
    return quizPack;
  }
}
