import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  final String name;
  final String imageUrl;
  final String priceKey;
  final bool isPremium;

  Quiz(
    this.id,
    this.imageUrl,
    this.priceKey,
    this.name,
    this.isPremium,
  );

  Quiz.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imageUrl = json['image'],
        priceKey = json['key'],
        isPremium = json['is_premium'];
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

  Future getCategoires({bool isQuiz = false}) async {
    try {
      String url = isQuiz
          ? "http://68.183.71.76:8000/quiz"
          : "http://68.183.71.76:8000/categories";

      final response = await http.get(url);
      final data = json.decode(utf8.decode(response.bodyBytes));
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
}
