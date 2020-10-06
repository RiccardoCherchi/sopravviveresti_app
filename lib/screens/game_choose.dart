import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_type.dart';

import '../providers/categories.dart';
import '../providers/questions.dart';

import '../screens/categories.dart';
import '../screens/question.dart';
import '../screens/quizzes.dart';

import '../widgets/game_card.dart';

class ChooseGame extends StatelessWidget {
  static const routeName = '/choose-game';

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final _categories = Provider.of<Categories>(context, listen: false);
    final _questions = Provider.of<Questions>(context, listen: false);

    void showSocketError() async {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Row(
            children: [
              Icon(Icons.signal_wifi_off),
              SizedBox(width: 10),
              Container(
                child: Text(
                  "Connessione fallita",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    void _openClassic() async {
      try {
        await _categories.getCategoires();
        Navigator.of(context).pushNamed(CategoriesScreen.routeName);
      } on SocketException catch (_) {
        showSocketError();
      }
    }

    void _openGeneralCulture() async {
      try {
        await _questions.getNewQuestion(gameType: GameType.general_question);
        Navigator.of(context).pushNamed(Question.routeName, arguments: {
          "isGeneralCultureQuestion": true,
          "isQuizQuestion": false,
        });
      } on SocketException catch (_) {
        showSocketError();
      }
    }

    void _openQuiz() async {
      try {
        await _categories.getCategoires(isQuiz: true);
        Navigator.of(context).pushNamed(Quizzes.routeName, arguments: {
          "isGeneralCultureQuestion": false,
          "isQuizQuestion": true,
        });
      } on SocketException catch (_) {
        showSocketError();
      }
    }

    return Scaffold(
      key: _scaffoldKey,
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
          LayoutBuilder(
            builder: (_, size) => Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, bottom: 10),
                        child: Text(
                          "GIOCA",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontFamily: "Anton",
                                fontSize: 35,
                                color: Theme.of(context).primaryColor,
                                letterSpacing: 2.5,
                              ),
                        ),
                      ),
                      Container(
                        width: size.maxWidth * .6,
                        child: Text(
                          "Scegli a che \nmodalità giocare",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: size.maxWidth * .8,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      children: [
                        GameCard(
                          title: "Modalità classica",
                          content:
                              "Hai due opzioni per salvarti: quale sarà quella giusta?",
                          width: size.maxWidth * .8,
                          imagePath: "assets/images/fire_draw.svg",
                          onPressed: _openClassic,
                        ),
                        GameCard(
                          title: "Modalità quiz",
                          content: "Domande sulla conoscenza. Quante ne sai?",
                          width: size.maxWidth * .8,
                          imagePath: "assets/images/earth_draw.svg",
                          onPressed: _openGeneralCulture,
                        ),
                        GameCard(
                          title: "Modalità domande multiple",
                          content:
                              "Un corso di sopravvivenza a domande, sopravviverai?",
                          width: size.maxWidth * .8,
                          imagePath: "assets/images/mountain_draw.svg",
                          onPressed: _openQuiz,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
