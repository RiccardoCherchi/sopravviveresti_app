import 'package:flutter/material.dart';

class TitleAppBar extends StatelessWidget {
  final String title;
  final String content;

  TitleAppBar({@required this.title, @required this.content});
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          )),
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                  ),
            ),
            Container(
              width: _size.width * .8,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                content,
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
