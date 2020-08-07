import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home.dart';
import './screens/categories.dart';
import './screens/question.dart';

import './providers/question.dart';
import './providers/categories.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        theme: ThemeData(
          primaryColor: Color(0xff6FCF97),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
        routes: {
          CategoriesScreen.routeName: (_) => CategoriesScreen(),
          Question.routeName: (_) => Question(),
        },
      ),
    );
  }
}
