import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/third_button.dart';
import '../widgets/question_solution.dart';
import '../widgets/app_bars/explanation_bar.dart';

import '../providers/question.dart';

class Explanation extends StatelessWidget {
  static const routeName = '/explanation';

  @override
  Widget build(BuildContext context) {
    final String _explanation = Provider.of<Questions>(context, listen: false)
        .activeQuestion
        .explanation;

    final _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildExplanationppBar(context),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              QuestionSolutionContainer(_explanation),
              SizedBox(height: 20),
              Container(
                width: _size.width * .8,
                height: _size.height * .3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 20),
              ThirdButton(
                "Fine",
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
