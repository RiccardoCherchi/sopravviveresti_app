import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopravviveresti_app/widgets/custom_button.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../providers/categories.dart';
import '../providers/questions.dart';
import '../providers/hearts.dart';

import '../screens/question.dart';

import '../widgets/quiz_card.dart';
import '../widgets/app_bars/title.dart';
import '../widgets/custon_dialog.dart';

class Quizzes extends StatefulWidget {
  static const routeName = '/quizzes';

  @override
  _QuizzesState createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  @override
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      // _handlePurchaseUpdates(purchases);
    });
    test();
    super.initState();
  }

  void test() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    print(available);
    const Set<String> _kIds = {'single_quiz', 'product2'};
    final ProductDetailsResponse response =
        await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      print(response.notFoundIDs);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final _quizzes = Provider.of<Categories>(context, listen: false);
    final _questions = Provider.of<Questions>(context, listen: false);

    void _loadQuestion(int id) async {
      final currentQuiz =
          _quizzes.categories.firstWhere((element) => element.id == id);
      if (currentQuiz.isPremium) {
        showDialog(
          context: context,
          builder: (_) => BuyQuizDialog(currentQuiz.name),
        );
      } else {
        _questions.resetQuizIndex();
        await _questions.getQuizQuestion(id);
        Provider.of<Hearts>(context, listen: false).getHearts();
        Navigator.of(context).pushNamed(Question.routeName, arguments: {
          "isQuizQuestion": true,
          "isGeneralCultureQuestion": false,
        });
      }
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

class BuyQuizDialog extends StatelessWidget {
  final String name;

  BuyQuizDialog(this.name);
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Acquista il quiz',
      color: Theme.of(context).primaryColor,
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Acquista $name",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 15,
              ),
              child: CustomButton(
                "Acquista €2,99",
                onPressed: () {},
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
