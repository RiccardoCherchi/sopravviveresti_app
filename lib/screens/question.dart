import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../helpers/ads.dart';

import '../providers/questions.dart';
import '../providers/show_ads.dart';

import '../widgets/app_bars/game_app_bar.dart';
import '../widgets/question_solution.dart';
import '../widgets/answer.dart';
import '../widgets/custom_button.dart';

import '../models/question_type.dart';

import '../screens/explanation.dart';
import '../screens/game_choose.dart';

class MyAndroidScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyIosScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      ClampingScrollPhysics();
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
    final Map _routeArguments =
        ModalRoute.of(context).settings.arguments as Map;

    final bool _isGeneralQuestion = _routeArguments != null
        ? _routeArguments['isGeneralCultureQuestion']
        : false;

    final _questions = Provider.of<Questions>(context, listen: false);
    final _showAds = Provider.of<ShowAds>(context, listen: false);

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
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontFamily: "Anton",
              letterSpacing: 2.5,
            ),
          ),
          onFinished: _endTIme,
        ),
      ),
      body: ScrollConfiguration(
        behavior:
            Platform.isIOS ? MyIosScrollBehavior() : MyAndroidScrollBehavior(),
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
                                    child: ExplanationContainer(
                                      Answer(
                                        active: _active,
                                        choosed: _questions
                                                .activeQuestion.answers
                                                .indexOf(e) ==
                                            _choosed,
                                        content: e['content'],
                                        questionType: e['type'],
                                      ),
                                      active: _active &&
                                          e['type'] == QuestionType.correct &&
                                          _isGeneralQuestion,
                                      explanation:
                                          _questions.activeQuestion.explanation,
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
                            _isGeneralQuestion
                                ? "Prossima domanda"
                                : _choosed != null
                                    ? "Scopri perchè"
                                    : "Soluzione",
                            onPressed: () async {
                              if (_isGeneralQuestion) {
                                final ads = Ads();
                                InterstitialAd interstitialAd =
                                    ads.createInterstitialAd();

                                if (_showAds.count == 3) {
                                  interstitialAd
                                    ..load()
                                    ..show();
                                }

                                _showAds.increseCounter();
                                print(_showAds.count);

                                await _questions.getNewQuestion(
                                    isGeneralCuluture: true);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    Question.routeName,
                                    ModalRoute.withName(ChooseGame.routeName),
                                    arguments: {
                                      "isGeneralCultureQuestion": true,
                                    });
                              } else {
                                final bool status =
                                    await _questions.checkSavedQuestion(
                                  _questions.activeQuestion.id,
                                );
                                Navigator.of(context).pushReplacementNamed(
                                  Explanation.routeName,
                                  arguments: {
                                    "id": _questions.activeQuestion.id,
                                    "status": status,
                                  },
                                );
                              }
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

class ExplanationContainer extends StatelessWidget {
  final Answer answer;
  final bool active;
  final String explanation;

  ExplanationContainer(this.answer,
      {@required this.active, @required this.explanation});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Stack(
        children: [
          Center(child: answer),
          if (active)
            Positioned(
              top: -10,
              right: 20,
              child: Container(
                child: IconButton(
                  icon: Icon(
                    Icons.help,
                    size: 30,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          child: Stack(
                            children: [
                              Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 15.0,
                                        bottom: 10.0,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Spiegazione",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                letterSpacing: 1.5,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 20,
                                      ),
                                      child: Text(
                                        explanation,
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      padding: new EdgeInsets.all(0.0),
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    );
                  },
                ),
              ),
            ),
        ],
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
