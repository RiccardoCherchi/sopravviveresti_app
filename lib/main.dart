import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sopravviveresti_app/screens/score.dart';

import './screens/home.dart';
import './screens/categories.dart';
import './screens/question.dart';
import './screens/explanation.dart';
import './screens/favorites.dart';
import './screens/game_choose.dart';
import './screens/quizzes.dart';

import './providers/questions.dart';
import './providers/categories.dart';
import './providers/products.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Questions(),
        ),
        ChangeNotifierProvider(
          create: (_) => Categories(),
        ),
        ChangeNotifierProvider(
          create: (_) => Products(),
        )
      ],
      child: MaterialApp(
        title: 'Sopravviveresti?',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xff6FCF97),
            accentColor: Colors.yellow[600],
            fontFamily: "Montserrat",
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: TextTheme(
              headline5: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.bold),
            )),
        home: Home(),
        routes: {
          CategoriesScreen.routeName: (_) => CategoriesScreen(),
          Question.routeName: (_) => Question(),
          Explanation.routeName: (_) => Explanation(),
          Favorites.routeName: (_) => Favorites(),
          ChooseGame.routeName: (_) => ChooseGame(),
          Quizzes.routeName: (_) => Quizzes(),
          QuizScore.routeName: (_) => QuizScore(),
        },
      ),
    );
  }
}
