import 'dart:io';

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

import '../custom_dialog.dart';
import '../custom_button.dart';

Widget buildGameAppBar(
  BuildContext context, {
  @required Countdown countdown,
  Function buyHearts,
  bool isQuiz = false,
  int hearts,
}) {
  final _size = MediaQuery.of(context).size;

  return PreferredSize(
    preferredSize: Size.fromHeight(100.0),
    child: Container(
      padding: EdgeInsets.only(
        left: _size.width * .02,
        right: _size.width * .02,
      ),
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: Container(
                width: 40,
                alignment: Alignment.center,
                child: countdown,
              ),
            ),
            isQuiz
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => BuyNewLives(buyHearts),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Color(0xffFF4F4F),
                          size: 40,
                        ),
                        SizedBox(width: 2),
                        Text(
                          hearts.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  )
                : IconButton(
                    onPressed: () => Share.text(
                        'Sopravviveresti?',
                        'Sei in una situazione di pericolo e hai due opzioni per salvarti: quale delle due sarà la tua salvezza? \n${Platform.isIOS ? 'https://apps.apple.com/app/id1529738913' : 'https://play.google.com/store/apps/details?id=com.hmimo.sopravviveresti'}',
                        'text/plain'),
                    icon: Icon(
                      Icons.share,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}

class BuyNewLives extends StatelessWidget {
  final Function buyLives;

  BuyNewLives(this.buyLives);
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Acquista 5 vite',
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: Column(
          children: [
            Text(
              "Acquista 5 nuove vite da usare nel gioco",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
              child: CustomButton(
                "Acquista",
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                onPressed: buyLives,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
