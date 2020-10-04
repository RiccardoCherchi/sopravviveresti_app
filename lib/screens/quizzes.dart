import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/questions.dart';
import '../providers/hearts.dart';

import '../screens/question.dart';

import '../widgets/quiz_card.dart';
import '../widgets/app_bars/title.dart';

class Quizzes extends StatelessWidget {
  static const routeName = '/quizzes';

  @override
  Widget build(BuildContext context) {
    final _quizzes = Provider.of<Categories>(context, listen: false);
    final _questions = Provider.of<Questions>(context, listen: false);

    void _loadQuestion(int id) async {
      _questions.resetQuizIndex();
      await _questions.getQuizQuestion(id);
      Provider.of<Hearts>(context, listen: false).getHearts();
      Navigator.of(context).pushNamed(Question.routeName, arguments: {
        "isQuizQuestion": true,
        "isGeneralCultureQuestion": false,
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                TitleAppBar(
                  title: "gioca",
                  content: "Quiz multidomanda basati su un’unica situazione",
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemBuilder: (_, i) => Container(
                        child: GestureDetector(
                          child: QuizCard(
                            category: _quizzes.categories[i],
                          ),
                          onTap: () => _loadQuestion(_quizzes.categories[i].id),
                        ),
                      ),
                      itemCount: _quizzes.categories.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
