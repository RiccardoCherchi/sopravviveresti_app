import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopravviveresti_app/models/question_type.dart';
import 'package:sopravviveresti_app/screens/categories.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../providers/questions.dart';

import '../widgets/app_bars/game_app_bar.dart';
import '../widgets/question_solution.dart';
import '../widgets/answer.dart';
import '../widgets/custom_button.dart';

import '../screens/explanation.dart';

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class Question extends StatefulWidget {
  static const routeName = '/question';

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  bool _active = false;
  int _choosed;

  final _controller = CountdownController();

  @override
  Widget build(BuildContext context) {
    final _questions = Provider.of<Questions>(context, listen: false);

    void _resolve(Map question) {
      if (!_active) {
        setState(() {
          _controller.pause();
          _active = true;
          _choosed = _questions.activeQuestion.answers.indexOf(question);
        });
      }
    }

    void _endTIme() {
      setState(() {
        _active = true;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildGameAppBar(
        context,
        countdown: Countdown(
          controller: _controller,
          seconds: 30,
          build: (_, time) => Text(
            time.toStringAsFixed(0),
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          onFinished: _endTIme,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.only(bottom: 100),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: QuestionSolutionContainer(
                    _questions.activeQuestion.situation,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: CustomPaint(
                  painter: AnswerContainer(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: _questions.activeQuestion.answers
                              .map(
                                (e) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: GestureDetector(
                                    onTap: () => _resolve(e),
                                    child: Answer(
                                      active: _active,
                                      choosed: _questions.activeQuestion.answers
                                              .indexOf(e) ==
                                          _choosed,
                                      content: e['content'],
                                      questionType: e['type'],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 35),
                      if (_active == false)
                        Container(
                          child: Text(
                            'E tu, sopravviveresti?',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      if (_active == true && _choosed != null)
                        Container(
                          child: Text(
                            _questions.activeQuestion.answers[_choosed]
                                        ['type'] ==
                                    QuestionType.correct
                                ? "Risposta esatta!"
                                : "Risposta errata!",
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: getColor(
                                          context,
                                          _questions.activeQuestion
                                              .answers[_choosed]['type']),
                                    ),
                          ),
                        ),
                      if (_active == true && _choosed == null)
                        Container(
                          child: Text(
                            "Tempo scaduto!",
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).errorColor,
                                    ),
                          ),
                        ),
                      SizedBox(height: 20),
                      if (_active)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: CustomButton(
                            _choosed != null ? "Scopri perchè" : "Soluzione",
                            icon: Icons.arrow_forward,
                            onPressed: () async {
                              final bool status =
                                  await _questions.checkSavedQuestion(
                                      _questions.activeQuestion.id);
                              Navigator.of(context).pushReplacementNamed(
                                  Explanation.routeName,
                                  arguments: {
                                    "id": _questions.activeQuestion.id,
                                    "status": status,
                                  });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnswerContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.quadraticBezierTo(size.width / 2, -25, size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
