import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../styles/sopravviveresti_icons.dart';

import '../helpers/check_version.dart';

import '../widgets/home_button.dart';
import '../widgets/custom_button.dart';

import '../screens/game_choose.dart';
import '../screens/favorites.dart';

import '../providers/products.dart';

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

  bool _versionStatus = true;

  @override
  void initState() {
    _checkVersion();
    getPastPurchases();
    super.initState();
  }

  void _checkVersion() async {
    final status = await checkAppVersion();
    print("version status: $status");
    setState(() {
      _versionStatus = status;
    });
    if (!status) {
      _showVersionDialog();
    }
  }

  void getPastPurchases() async {
    await Provider.of<Products>(context, listen: false).getPastPurchases();
  }

  Future _showVersionDialog() {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  'assets/images/update_icon.svg',
                  width: 60,
                ),
              ),
              Text(
                "Aggiorna l’app per utilizzarla",
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Abbiamo fatto dei lavori di ristrutturazione, e per continuare ad utilizzare l’app è necessario aggiornarla",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 150,
                child: CustomButton(
                  "Aggiorna",
                  color: Theme.of(context).primaryColor,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  borderWidth: 4,
                  onPressed: () {
                    launch(
                      Platform.isIOS
                          ? "https://apps.apple.com/app/id1529738913"
                          : "https://play.google.com/store/apps/details?id=com.hmimo.sopravviveresti",
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: Container(
          child: Container(
            margin: const EdgeInsets.only(top: 40, bottom: 0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Sopravviveresti',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontFamily: "Anton",
                          fontSize: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    child: Text(
                      "Quiz sulla sopravvivenza e sulla natura con tre modalità di gioco: quante ne sai?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 55),
                  child: CustomButton(
                    "Ripristina acquisti",
                    color: Theme.of(context).primaryColor,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    onPressed: () {
                      Provider.of<Products>(context, listen: false)
                          .getPastPurchases();
                    },
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      CustomButton(
                        "Privacy policy",
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        onPressed: () => launch(
                            "https://howmuchismyoutfit.com/policies/sopravviveresti/policy.html"),
                      ),
                      SizedBox(height: 15),
                      CustomButton(
                        "Termini e condizioni",
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        onPressed: () => launch(
                            "https://howmuchismyoutfit.com/policies/sopravviveresti/terms.html"),
                      ),
                      GestureDetector(
                        onTap: () => launch(
                          "https://www.instagram.com/sopravviveresti/",
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.instagram),
                              SizedBox(width: 5),
                              Text(
                                "@sopravviveresti",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
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
                  onPressed: () {
                    if (_versionStatus) {
                      Navigator.of(context).pushNamed(ChooseGame.routeName);
                    } else {
                      _showVersionDialog();
                    }
                  },
                ),
                HomeButton(
                  text: 'Preferiti',
                  icon: Icons.star,
                  onPressed: () {
                    if (_versionStatus) {
                      Navigator.of(context).pushNamed(Favorites.routeName);
                    } else {
                      _showVersionDialog();
                    }
                  },
                ),
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
