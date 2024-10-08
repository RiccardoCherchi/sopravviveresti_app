import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_type.dart';

import '../widgets/custom_button.dart';
import '../widgets/question_solution.dart';
import '../widgets/app_bars/explanation_bar.dart';

import '../providers/questions.dart';

import '../screens/question.dart';
import '../screens/categories.dart';

class Explanation extends StatelessWidget {
  static const routeName = '/explanation';

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    final _questions = Provider.of<Questions>(context, listen: false);
    final String _explanation = _questions.activeQuestion?.explanation;

    final Map _routeArguments =
        ModalRoute.of(context).settings.arguments as Map;
    final String _localExplanation =
        _routeArguments != null ? _routeArguments['explanation'] : null;
    final int _situationId =
        _routeArguments != null ? _routeArguments['id'] : null;
    final bool _status =
        _routeArguments != null ? _routeArguments['status'] : null;

    final _size = MediaQuery.of(context).size;

    void _end() async {
      if (_localExplanation != null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      } else {
        await _questions.getNewQuestion(
          categoryId: _questions.lastCategoryId,
          gameType: GameType.classic,
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          Question.routeName,
          ModalRoute.withName(CategoriesScreen.routeName),
        );
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: buildExplanationppBar(context,
          scaffoldKey: _scaffoldKey, status: _status, id: _situationId),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        alignment: Alignment.topCenter,
        child: ScrollConfiguration(
          behavior: Platform.isIOS
              ? MyIosScrollBehavior()
              : MyAndroidScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                QuestionSolutionContainer(
                  _localExplanation == null ? _explanation : _localExplanation,
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/solution_image.png',
                  width: _size.width * .7,
                ),
                SizedBox(height: 20),
                CustomButton(
                  _localExplanation != null ? "Fine" : "Prossima domanda",
                  onPressed: () => _end(),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
