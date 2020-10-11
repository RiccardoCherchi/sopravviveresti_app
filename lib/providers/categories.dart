import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Category {
  final int id;
  final String name;
  final bool isPremium;
  final String imageUrl;
  final String priceKey;

  Category(this.id, this.name, this.isPremium, this.imageUrl, this.priceKey);

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        isPremium = json['is_premium'],
        imageUrl = json['image'],
        priceKey = json['key'];
}

class Categories with ChangeNotifier {
  List<Category> _categories;

  List<Category> get categories {
    return _categories;
  }

  Future getCategoires({bool isQuiz}) async {
    try {
      String url = isQuiz
          ? "http://68.183.71.76:8000/quiz"
          : "http://68.183.71.76:8000/categories";

      final response = await http.get(url);
      final data = json.decode(utf8.decode(response.bodyBytes));
      List<Category> _loadedCateogires = [];
      data.forEach((e) {
        _loadedCateogires.add(Category.fromJson(e));
      });
      _categories = _loadedCateogires;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
