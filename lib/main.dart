import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home.dart';
import './screens/categories.dart';
import './screens/question.dart';
import './screens/explanation.dart';
import './screens/favorites.dart';

import 'providers/questions.dart';
import './providers/categories.dart';

void main() {
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xff6FCF97),
            accentColor: Colors.yellow,
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
        },
      ),
    );
  }
}
