import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Category {
  final int id;
  final String name;

  Category(this.id, this.name);

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class Categories with ChangeNotifier {
  List<Category> _categories;

  List<Category> get categories {
    return _categories;
  }

  Future getCateogires() async {
    final response = await http.get("http://68.183.71.76:8000/categories");
    final data = json.decode(utf8.decode(response.bodyBytes));
    print(data);
    List<Category> _loadedCateogires = [];
    data.forEach((e) {
      _loadedCateogires.add(Category.fromJson(e));
    });
    print(_loadedCateogires);
    _categories = _loadedCateogires;
    notifyListeners();
  }
}
