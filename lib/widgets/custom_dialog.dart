import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final String title;
  final Color color;

  CustomDialog({
    @required this.child,
    @required this.title,
    this.color = Colors.black,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Stack(
          children: [
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      bottom: 5.0,
                    ),
                    child: Center(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              letterSpacing: 1,
                              color: color,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: child,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: new EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
