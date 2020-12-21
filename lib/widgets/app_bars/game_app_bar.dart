import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

Widget buildGameAppBar(
  BuildContext context, {
  @required Countdown countdown,
}) {
  final _size = MediaQuery.of(context).size;

  return PreferredSize(
    preferredSize: Size.fromHeight(100.0),
    child: Container(
      padding: EdgeInsets.only(
        left: _size.width * .02,
        right: _size.width * .02,
      ),
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: Container(
                width: 40,
                alignment: Alignment.center,
                child: countdown,
              ),
            ),
            // Timer(
            //   countdown: countdown,
            // ),
            // CustomPaint(
            //   painter: TimerPainter(
            //     mainColor: Theme.of(context).primaryColor,
            //   ),
            //   child: Container(
            //     width: 40,
            //     alignment: Alignment.center,
            //     child: countdown,
            //   ),
            // ),
            IconButton(
              onPressed: () => Share.text(
                  'Sopravviveresti?',
                  'Sei in una situazione di pericolo e hai due opzioni per salvarti: quale delle due sarà la tua salvezza? \n${Platform.isIOS ? 'https://apps.apple.com/app/id1529738913' : 'https://play.google.com/store/apps/details?id=com.hmimo.sopravviveresti'}',
                  'text/plain'),
              icon: Icon(
                Icons.share,
                size: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class Timer extends StatefulWidget {
  final Countdown countdown;

  Timer({@required this.countdown});
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> with SingleTickerProviderStateMixin {
  AnimationController timerProgressController;
  Animation timerAnimation;

  @override
  void initState() {
    super.initState();
    timerProgressController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.countdown.seconds,
      ),
    );
    print("seconds: ${widget.countdown.seconds}");
    timerAnimation = Tween(begin: 0, end: 30).animate(timerProgressController)
      ..addListener(() {
        setState(() {});
        print("timer");
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TimerPainter(
        mainColor: Theme.of(context).primaryColor,
        timerProgress: timerAnimation.value,
      ),
      child: Container(
        width: 40,
        alignment: Alignment.center,
        child: widget.countdown,
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final Color mainColor;
  final int timerProgress;

  TimerPainter({
    @required this.mainColor,
    @required this.timerProgress,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final body = Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // final angle = 3 * pi * (50 / 100);

    // canvas.drawCircle(center, 35, border);
    double angle = 2 * pi * (timerProgress / 100);
    print(angle);

    canvas.drawArc(Rect.fromCircle(center: center, radius: 35), -pi / 2, angle,
        true, border);

    canvas.drawCircle(center, 30, body);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
