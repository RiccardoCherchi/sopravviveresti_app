import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/questions.dart';

import '../widgets/question_solution.dart';

import '../screens/explanation.dart';

class Favorites extends StatefulWidget {
  static const routeName = '/favorites';

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<QuestionData> _questions;
  bool _loaded = false;

  @override
  void initState() {
    getQuestions();
    super.initState();
  }

  void getQuestions() async {
    final questions = await Provider.of<Questions>(context, listen: false)
        .getLocallySavedQuestion();
    setState(() {
      _questions = questions;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

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
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                )),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SOLUZIONI SALVATE',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25,
                        ),
                  ),
                  Container(
                    width: _size.width * .8,
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "Salva le soluzioni che preferisci per conservarle e consultarle quando vuoi",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _loaded
              ? _questions.length > 0
                  ? Center(
                      child: Container(
                          width: _size.width * .8,
                          margin: EdgeInsets.only(
                            top: _size.height * .28,
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, i) => Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      Explanation.routeName,
                                      arguments: {
                                        "id": _questions[i].id,
                                        "explanation":
                                            _questions[i].explanation,
                                        "status": true,
                                      });
                                },
                                child: QuestionSolutionContainer(
                                  _questions[i].situation,
                                  fontSize: 18,
                                  solution: true,
                                ),
                              ),
                            ),
                            itemCount: _questions.length,
                          )),
                    )
                  : Center(
                      child: Container(
                        child: QuestionSolutionContainer(
                          "Ancora nessuna soluzione salvata :( \nClicca sulla stellina in alto a sinistra nella schermata delle soluzioni per salvarne una!",
                        ),
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
        ],
      ),
    );
  }
}
