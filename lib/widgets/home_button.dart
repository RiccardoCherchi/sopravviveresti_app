import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final IconData icon;

  HomeButton(
      {@required this.onPressed, @required this.text, @required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * .8,
      height: 60,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              text.toUpperCase(),
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Anton',
                    letterSpacing: 2.5,
                    fontSize: 30,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
