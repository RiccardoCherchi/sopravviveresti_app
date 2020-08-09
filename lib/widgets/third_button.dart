import 'package:flutter/material.dart';

class ThirdButton extends StatelessWidget {
  final String content;
  final Function onPressed;
  final IconData icon;

  ThirdButton(this.content, {@required this.onPressed, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * .6,
      child: RaisedButton(
        onPressed: onPressed,
        disabledColor: Colors.white,
        disabledTextColor: Colors.black,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.yellow,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            if (icon != null)
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Icon(icon),
              ),
          ],
        ),
      ),
    );
  }
}
