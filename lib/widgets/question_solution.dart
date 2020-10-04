import 'package:flutter/material.dart';

class QuestionSolutionContainer extends StatelessWidget {
  final String content;
  final double fontSize;
  final bool solution;
  final int level;
  final int maxLevel;

  QuestionSolutionContainer(
    this.content, {
    this.fontSize = 22,
    this.solution = false,
    this.maxLevel = 10,
    this.level,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .8,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 10,
                  color: Colors.black26,
                ),
                BoxShadow(
                  blurRadius: 0,
                  spreadRadius: 0,
                  color: Colors.white,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          if (level != null)
            Positioned(
              top: 10,
              left: MediaQuery.of(context).size.width * .5 - 80,
              child: Container(
                width: 80,
                height: 25,
                decoration: BoxDecoration(
                  color: Color(0xffFFD037),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "$level/$maxLevel",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
