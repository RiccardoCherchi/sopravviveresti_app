// import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

Widget buildGameAppBar(BuildContext context, {@required Countdown countdown}) {
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
            Icon(
              Icons.sync,
              size: 40,
              color: Colors.white,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Container(
                width: 40,
                alignment: Alignment.center,
                child: countdown,
              ),
            ),
            Icon(
              Icons.home,
              size: 40,
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}

// class Timer extends StatefulWidget {
//   final Countdown countdown;

//   Timer(this.countdown);
//   @override
//   _TimerState createState() => _TimerState();
// }

// class _TimerState extends State<Timer> with TickerProviderStateMixin {
//   AnimationController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: widget.countdown,
//     );
//   }
// }

// class CustomTimerPainter extends CustomPainter {
//   CustomTimerPainter({
//     this.animation,
//     this.fillColor,
//     this.color,
//     this.strokeWidth,
//   }) : super(repaint: animation);

//   final Animation<double> animation;
//   final Color fillColor, color;
//   final double strokeWidth;

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = fillColor
//       ..strokeWidth = strokeWidth ?? 5.0
//       ..strokeCap = StrokeCap.butt
//       ..style = PaintingStyle.stroke;

//     canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
//     paint.color = color;
//     double progress = (1.0 - animation.value) * 2 * math.pi;
//     canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
//   }

//   @override
//   bool shouldRepaint(CustomTimerPainter old) {
//     return animation.value != old.animation.value ||
//         color != old.color ||
//         fillColor != old.fillColor;
//   }
// }
