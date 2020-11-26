import 'package:flutter/material.dart';

import '../providers/categories.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final bool unlocked;

  QuizCard({
    @required this.quiz,
    @required this.unlocked,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: MediaQuery.of(context).size.width * .10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Image.network(
              quiz.imageUrl,
              width: MediaQuery.of(context).size.width * .8,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, bottom: 20, left: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text(
                            quiz.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Text(
                          "20 domande",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (quiz.isPremium && !unlocked)
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
