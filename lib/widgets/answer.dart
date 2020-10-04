import 'package:flutter/material.dart';
import 'package:sopravviveresti_app/models/question_type.dart';

class Answer extends StatelessWidget {
  final String content;
  final QuestionType questionType;
  final bool active;
  final bool choosed;

  final String explanation;

  Answer({
    @required this.content,
    @required this.questionType,
    @required this.active,
    @required this.choosed,
    this.explanation,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: active
              ? Border.all(
                  color: getColor(context, questionType),
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              blurRadius: 7,
              spreadRadius: 1,
              color: Colors.grey[400],
            ),
            BoxShadow(
              blurRadius: 0,
              spreadRadius: 0,
              color: Colors.white,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            if (choosed)
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Icon(
                  questionType == QuestionType.correct
                      ? Icons.done
                      : Icons.close,
                  size: 30,
                  color: getColor(context, questionType),
                ),
              )
          ],
        ),
      ),
    );
  }
}

Color getColor(BuildContext context, QuestionType questionType) {
  return questionType == QuestionType.correct
      ? Theme.of(context).primaryColor
      : Theme.of(context).errorColor;
}
