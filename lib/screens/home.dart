import 'package:flutter/material.dart';
import '../styles/sopravviveresti_icons.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/question.dart';

import '../widgets/home_button.dart';

import '../screens/categories.dart';
import '../screens/favorites.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _cateories = Provider.of<Categories>(context);
    final _questions = Provider.of<Questions>(context);

    final _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HomeButton(
                  text: 'Gioca',
                  icon: Sopravviveresti.thunder,
                  onPressed: () async {
                    await _cateories.getCateogires();
                    Navigator.of(context).pushNamed(CategoriesScreen.routeName);
                  },
                ),
                HomeButton(
                  text: 'Preferiti',
                  icon: Icons.star,
                  onPressed: () {
                    Navigator.of(context).pushNamed(Favorites.routeName);
                  },
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            alignment: Alignment.topCenter,
            child: Text('LOGO', style: Theme.of(context).textTheme.headline5),
          ),
          Positioned(
            top: _size.height * .2,
            right: 0,
            child: Container(
              height: 50,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: null,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
