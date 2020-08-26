import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/questions.dart';

SnackBar buildSnackBar(BuildContext context, String content) {
  return SnackBar(
    content: Text(
      content,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: Theme.of(context).primaryColor,
  );
}

Widget buildExplanationppBar(
  BuildContext context, {
  bool status = false,
  int id,
  @required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  void _saveQuestion() async {
    final questions = Provider.of<Questions>(context, listen: false);

    await questions.saveCurrentQuestionLocally();
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      buildSnackBar(context, "Soluzione salvata!"),
    );
  }

  void _removeQuestion() async {
    final questions = Provider.of<Questions>(context, listen: false);

    await questions.deleteLocallySavedQuestion(id);
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(
      buildSnackBar(context, "Soluzione rimossa!"),
    );
  }

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
        padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // IconButton(
            //   icon: Icon(
            //     status ? Icons.star : Icons.star_border,
            //     size: 40,
            //     color: Colors.white,
            //   ),
            //   onPressed: _saveQuestion,
            // ),
            StarIcon(
              status,
              save: _saveQuestion,
              remove: _removeQuestion,
            ),
            Container(
              child: Text(
                'LOGO',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
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
          ],
        ),
      ),
    ),
  );
}

class StarIcon extends StatefulWidget {
  final bool status;
  final Function save;
  final Function remove;

  StarIcon(this.status, {@required this.save, @required this.remove});
  @override
  _StarIconState createState() => _StarIconState();
}

class _StarIconState extends State<StarIcon> {
  bool _active = false;

  @override
  void initState() {
    _active = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(
          _active ? Icons.star : Icons.star_border,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () {
          if (!widget.status && !_active) {
            widget.save();
            setState(() {
              _active = true;
            });
          }
          if (widget.status && _active) {
            widget.remove();
            setState(() {
              _active = false;
            });
          }
        },
      ),
    );
  }
}
