import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:sopravviveresti_app/widgets/app_bars/game_app_bar.dart';
import 'package:sopravviveresti_app/widgets/custom_button.dart';

import '../providers/questions.dart';
import '../providers/categories.dart';

import '../widgets/app_bars/explanation_bar.dart';

import '../screens/question.dart';

class QuizScore extends StatefulWidget {
  static const routeName = '/score';

  @override
  _QuizScoreState createState() => _QuizScoreState();
}

class _QuizScoreState extends State<QuizScore> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _questions = Provider.of<Questions>(context);
    final _quizzes = Provider.of<Categories>(context);

    final _currentQuiz = _quizzes.quizzes
        .firstWhere((element) => element.id == _questions.currentQuizId);

    return Scaffold(
      appBar: buildExplanationppBar(context, scaffoldKey: null, isQuiz: true),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: _size.height * .22,
              top: _size.height * .1,
              left: _size.width * .1,
              right: _size.width * .1,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Punteggio",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "risposte corrette: ${_questions.correctQuizAnswers}/${_questions.quizLength}",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey[200],
                  ),
                  child: FractionallySizedBox(
                    widthFactor:
                        (_questions.correctQuizAnswers / _questions.quizLength)
                            .toDouble(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow[600],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Text(
                          (_questions.correctQuizAnswers /
                                      _questions.quizLength *
                                      100)
                                  .toStringAsFixed(0) +
                              "%",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      _currentQuiz.imageUrl,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 40,
                    bottom: 10,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      _questions.resetQuizIndex();
                      _questions.setCorrectQuizAnswers = 0;
                      await _questions
                          .getQuizQuestion(_questions.currentQuizId);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Question.routeName,
                        (route) => false,
                        arguments: {
                          "isGeneralCultureQuestion": false,
                          "isQuizQuestion": true,
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.replay),
                        Text("RIPROVA"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 32,
            left: _size.width * .5 -
                75, // half of the screen - half of the box width
            child: SizedBox(
              width: 150,
              child: CustomButton(
                "Fine",
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                },
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
