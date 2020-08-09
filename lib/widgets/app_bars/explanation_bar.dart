import 'package:flutter/material.dart';

Widget buildExplanationppBar(BuildContext context) {
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
            Icon(
              Icons.sync,
              size: 40,
              color: Colors.white,
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
            Icon(
              Icons.home,
              size: 40,
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}
