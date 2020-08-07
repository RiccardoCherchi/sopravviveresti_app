import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../providers/question.dart';

import '../widgets/app_bars/game_app_bar.dart';

class Question extends StatelessWidget {
  static const routeName = '/question';

  @override
  Widget build(BuildContext context) {
    final _questions = Provider.of<Questions>(context, listen: false);

    return Scaffold(
      appBar: buildGameAppBar(
        context,
        countdown: Countdown(
          seconds: 30,
          build: (_, time) => Text(
            time.toStringAsFixed(0),
          ),
        ),
      ),
      body: Container(
        child: Text(_questions.activeQuestion.situation),
      ),
    );
  }
}
