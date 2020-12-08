import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopravviveresti_app/widgets/custom_button.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../providers/categories.dart';
import '../providers/questions.dart';

import '../screens/question.dart';

import '../widgets/quiz_card.dart';
import '../widgets/app_bars/title.dart';
import '../widgets/custom_dialog.dart';

import '../providers/products.dart';

class Quizzes extends StatefulWidget {
  static const routeName = '/quizzes';

  @override
  _QuizzesState createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  InAppPurchaseConnection _iap;

  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  @override
  void initState() {
    setState(() {
      _iap = InAppPurchaseConnection.instance;
    });
    _asyncInitState();
    super.initState();
  }

  void _asyncInitState() async {
    await _initPayaments();
    _getProducts();
    // await _getPastPurchases();
    _purchases = Provider.of<Products>(context, listen: false).purchases;
  }

  Future<void> _initPayaments() async {
    final bool available = await _iap.isAvailable();
    print("aviable $available");

    final Stream purchaseUpdates = _iap.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      print("new purchase: $purchases");
      (purchases as List).forEach((element) async {
        await _iap.completePurchase(element);
        Navigator.of(context).pop();
        setState(() {
          _purchases.add(element);
        });
      });
    });
  }

  // Future<void> _getPastPurchases() async {
  //   QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

  //   print(response.pastPurchases);
  //   setState(() {
  //     _purchases = response.pastPurchases;
  //   });
  //   _purchases.forEach((element) => print("buyed -> ${element.productID}"));

  // }

  Future<Set<String>> _getId() async {
    final quizzes = Provider.of<Categories>(context, listen: false)
        .quizzes
        .where((element) => element.isPremium)
        .map((e) => e.priceKey)
        .toList();

    final List<QuizPack> _packs =
        await Provider.of<Categories>(context, listen: false).getPacks();

    final List<String> _normalizedPacks =
        _packs.map((e) => e.priceKey).toList();

    quizzes.addAll(_normalizedPacks);
    return quizzes.toSet();
  }

  void _getProducts() async {
    final Set<String> _kIds = await _getId();
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      print("not founded ids: ${response.notFoundIDs}");
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final _quizzes = Provider.of<Categories>(context, listen: false);
    final _questions = Provider.of<Questions>(context, listen: false);

    void _buyQuiz(String id) async {
      final ProductDetails productDetails = _products.firstWhere(
        (element) => element.id == id,
      ); // Saved earlier from queryPastPurchases().

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }

    void _buyPack(String id) {
      final ProductDetails productDetails = _products.firstWhere(
        (element) => element.id == id,
      );

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }

    Future<bool> _checkQuizPurchase(int id) async {
      final quiz = _quizzes.quizzes.firstWhere((element) => element.id == id);
      final quizPurchase =
          _purchases.where((element) => element.productID == quiz.priceKey);

      final QuizPack pack = await _quizzes.getPackByQuiz(quiz.id);
      final packPurchase =
          _purchases.where((element) => element.productID == pack.priceKey);

      if (quizPurchase.isEmpty && packPurchase.isEmpty) {
        return false;
      } else {
        return true;
      }
    }

    void _loadQuestion(int id) async {
      final currentQuiz =
          _quizzes.quizzes.firstWhere((element) => element.id == id);

      final bool check = await _checkQuizPurchase(id);
      if (currentQuiz.isPremium && !check) {
        showDialog(
          context: context,
          builder: (_) => BuyQuizDialog(
            quiz: currentQuiz,
            buyQuiz: _buyQuiz,
            buyPack: _buyPack,
          ),
        );
      } else {
        _questions.resetQuizIndex();
        await _questions.getQuizQuestion(id);
        _questions.setCorrectQuizAnswers = 0;
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
                TitleAppBar(title: "gioca"),
                Expanded(
                  child: Container(
                    child: ListView(
                      children: _quizzes.quizzes
                          .map(
                            (e) => Container(
                              child: FutureBuilder<bool>(
                                  future: _checkQuizPurchase(e.id),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 50,
                                          ),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        child: QuizCard(
                                          quiz: e,
                                          unlocked: snapshot.data,
                                        ),
                                        onTap: () => _loadQuestion(e.id),
                                      );
                                    }
                                  }),
                            ),
                          )
                          .toList(),
                      // itemCount: _quizzes.quizzes.length,
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
  final Quiz quiz;
  final Function buyQuiz;
  final Function buyPack;

  BuyQuizDialog(
      {@required this.quiz, @required this.buyQuiz, @required this.buyPack});
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
                "${quiz.name}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Ogni acquisto supporta la produzione e contribuisce a mantenere l’app senza pubblicità!",
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 15,
                  ),
                  child: CustomButton(
                    "Acquista €2,29",
                    onPressed: () => buyQuiz(quiz.priceKey),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15,
                    top: 5,
                  ),
                  child: CustomButton(
                    "Acquista pacchetto",
                    onPressed: () async {
                      final QuizPack pack =
                          await Provider.of<Categories>(context, listen: false)
                              .getPackByQuiz(quiz.id);
                      showDialog(
                        context: context,
                        builder: (_) => BuyPackDialog(
                          quizPack: pack,
                          buyPack: buyPack,
                        ),
                      );
                    },
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BuyPackDialog extends StatelessWidget {
  final QuizPack quizPack;
  final Function buyPack;

  BuyPackDialog({@required this.quizPack, @required this.buyPack});
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Acquista pacchetto",
      color: Theme.of(context).primaryColor,
      child: Container(
        child: Column(
          children: [
            Text(
              'Contiene:',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Ogni acquisto supporta la produzione e contribuisce a mantenere l’app senza pubblicità!",
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                itemBuilder: (_, i) => Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 200,
                          child: Text(
                            "${quizPack.quizzes[i].name}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                itemCount: quizPack.quizzes.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: CustomButton(
                "Acquista ${quizPack.price}€",
                onPressed: () => buyPack(quizPack.priceKey),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
