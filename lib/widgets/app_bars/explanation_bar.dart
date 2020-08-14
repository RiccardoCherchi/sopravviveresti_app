import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../providers/question.dart';

Widget buildExplanationppBar(BuildContext context) {
  void _saveQuestion() {
    Provider.of<Questions>(context, listen: false).saveCurrentQuestionLocally();
    Fluttertoast.showToast(
      msg: "Situazione salvata!",
      backgroundColor: Colors.white.withOpacity(.8),
      textColor: Colors.black,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 22,
      gravity: ToastGravity.TOP,
    );
  }

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
        padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.star,
                size: 40,
                color: Colors.white,
              ),
              onPressed: _saveQuestion,
            ),
            Container(
              child: Text(
                'LOGO',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
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
          ],
        ),
      ),
    ),
  );
}
