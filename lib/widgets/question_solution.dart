import 'package:flutter/material.dart';

class QuestionSolutionContainer extends StatelessWidget {
  final String content;
  final double fontSize;
  final bool solution;

  QuestionSolutionContainer(this.content,
      {this.fontSize = 22, this.solution = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
            if (solution)
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Soluzione',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
