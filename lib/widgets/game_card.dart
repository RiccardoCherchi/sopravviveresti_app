import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GameCard extends StatelessWidget {
  final double width;
  final String imagePath;
  final String content;
  final String title;
  final Function onPressed;

  GameCard({
    @required this.width,
    @required this.imagePath,
    @required this.title,
    @required this.content,
    @required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: width * .5,
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onPressed,
                      child: Text(
                        "GIOCA",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.yellow),
                  ],
                )
              ],
            ),
            Container(
              child: SvgPicture.asset(
                imagePath,
                width: width * .3,
              ),
            )
          ],
        ),
      ),
    );
  }
}
