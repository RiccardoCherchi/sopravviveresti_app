import 'package:flutter/material.dart';

class QuestionSolutionContainer extends StatelessWidget {
  final String content;

  QuestionSolutionContainer(this.content);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
