import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../styles/sopravviveresti_icons.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';

import '../widgets/home_button.dart';

import '../screens/categories.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // remove
    final _cateories = Provider.of<Categories>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
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
                  text: 'Profilo',
                  icon: FontAwesomeIcons.userAlt,
                  onPressed: () {},
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            alignment: Alignment.topCenter,
            child: Text(
              'LOGO',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
