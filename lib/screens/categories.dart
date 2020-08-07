import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/question.dart';

import './question.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/categories';

  Widget build(BuildContext context) {
    final _categories = Provider.of<Categories>(context, listen: false);
    final _questions = Provider.of<Questions>(context, listen: false);

    void _loadQuestion([int categoryId]) async {
      await _questions.getNewQuestion(categoryId);
      Navigator.of(context).pushNamed(Question.routeName);
    }

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 60),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          "GIOCA",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Container(
                          height: 100,
                          child: ListView.builder(
                            itemBuilder: (_, i) => GestureDetector(
                              onTap: () =>
                                  _loadQuestion(_categories.categories[i].id),
                              child: Text(
                                "${_categories.categories[i].name}",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            itemCount: _categories.categories.length,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
