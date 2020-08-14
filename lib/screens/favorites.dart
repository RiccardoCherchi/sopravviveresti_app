import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/question.dart';

import '../widgets/question_solution.dart';

import '../screens/explanation.dart';

class Favorites extends StatefulWidget {
  static const routeName = '/favorites';

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<QuestionData> _questions;

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
            height: _size.height * .24,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _size.width * .05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'SOLUZIONI SALVATE',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: _size.width * .6,
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "Salva le soluzioni che preferisci per conservarle e consultarle quando vuoi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: _size.width * .8,
              margin: EdgeInsets.only(
                top: _size.height * .25,
              ),
              child: _questions != null
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (_, i) => Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                Explanation.routeName,
                                arguments: _questions[i].explanation);
                          },
                          child: QuestionSolutionContainer(
                            _questions[i].situation,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      itemCount: _questions.length,
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
