import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import '../styles/sopravviveresti_icons.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/categories.dart';

import '../widgets/home_button.dart';

import '../screens/categories.dart';
import '../screens/favorites.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/images/categories.svg'),
        null);
    precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/images/routePath.svg'),
        null);
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    final _cateories = Provider.of<Categories>(context);
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: Container(
          child: Container(
            margin: const EdgeInsets.only(top: 80, bottom: 40),
            child: Column(
              children: [
                Text(
                  "Hai qualche idea per una situazione da suggerirci?\nPensi che una soluzione sia parzialmente o del tutto errata?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () =>
                        launch('https://www.instagram.com/sopravviveresti/'),
                    child: Column(
                      children: [
                        Text(
                          "Scrivici su\nInstagram!",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        FaIcon(
                          FontAwesomeIcons.instagram,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Divider(
                  color: Colors.black45,
                  thickness: 1,
                  endIndent: 0,
                ),
                Container(
                  child: Column(
                    children: [
                      DrawerFooterElement(
                        "Privacy policy",
                        FontAwesomeIcons.lock,
                      ),
                      DrawerFooterElement(
                        "Termini e condizioni",
                        FontAwesomeIcons.questionCircle,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
                    try {
                      await _cateories.getCateogires();
                      Navigator.of(context)
                          .pushNamed(CategoriesScreen.routeName);
                    } on SocketException catch (e) {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          backgroundColor: Theme.of(context).primaryColor,
                          content: Row(
                            children: [
                              Icon(Icons.signal_wifi_off),
                              SizedBox(width: 10),
                              Container(
                                child: Text(
                                  "Connessione fallita",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
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
            child: Text(
              'Sopravviveresti',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontFamily: "Anton",
                    fontSize: 35,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
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
                  splashColor: Colors.transparent,
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DrawerFooterElement extends StatelessWidget {
  final String text;
  final IconData icon;

  DrawerFooterElement(this.text, this.icon);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 10),
          Icon(
            icon,
            size: 18,
          ),
        ],
      ),
    );
  }
}
