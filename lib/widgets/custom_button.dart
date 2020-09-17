import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String content;
  final Function onPressed;
  final IconData icon;
  final Color color;
  final bool disable;
  final double borderWidth;
  final TextStyle textStyle;

  CustomButton(
    this.content, {
    @required this.onPressed,
    this.icon,
    this.color,
    this.disable,
    this.borderWidth = 2,
    this.textStyle = const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * .65,
      child: RaisedButton(
        onPressed: disable == true ? null : onPressed,
        disabledColor: Colors.black38.withOpacity(.2),
        disabledTextColor: Colors.black,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: color != null ? color : Theme.of(context).accentColor,
            width: borderWidth,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: textStyle,
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
