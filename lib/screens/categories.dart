import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sopravviveresti_app/models/game_type.dart';

import '../providers/categories.dart';
import '../providers/questions.dart';

import '../widgets/custom_button.dart';

import '../models/game_type.dart';

import './question.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _categoryId;
  bool _random = false;

  Widget build(BuildContext context) {
    final _questions = Provider.of<Questions>(context, listen: false);
    final _categories = Provider.of<Categories>(context, listen: false);

    final _size = MediaQuery.of(context).size;

    void _loadQuestion([int categoryId]) async {
      await _questions.getNewQuestion(
        categoryId: categoryId,
        gameType: GameType.classic,
      );
      Navigator.of(context).pushNamed(Question.routeName);
    }

    void _openCategoryChooser() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => CategoryModal(),
      ).then((value) {
        if (value.runtimeType == int) {
          setState(() {
            _categoryId = value;
            _random = false;
          });
        }
        if (value.runtimeType == bool) {
          if (value) {
            setState(() {
              _categoryId = null;
              _random = true;
            });
          }
        }
      });
    }

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 60),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          "GIOCA",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontFamily: "Anton",
                                fontSize: 35,
                                color: Colors.grey[50],
                                letterSpacing: 2.5,
                              ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: _size.height * .07,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/routePath.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: CustomPaint(
                          painter: AnswerContainer(),
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: _size.height * .05,
                                ),
                                Container(
                                  child: CustomButton(
                                    _categoryId == null
                                        ? _random ? "Casuale" : "Categorie"
                                        : _categories
                                            .categories[_categoryId - 1].name,
                                    color: Theme.of(context).primaryColor,
                                    icon: _categoryId == null && !_random
                                        ? Icons.arrow_forward
                                        : Icons.check,
                                    onPressed: _openCategoryChooser,
                                  ),
                                ),
                                SizedBox(
                                  height: _size.height * .05,
                                ),
                                if (_size.height > 660)
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/images/categories.svg',
                                    ),
                                  ),
                                SizedBox(
                                  height: _size.height * .05,
                                ),
                                Container(
                                  child: CustomButton(
                                    "Gioca",
                                    disable:
                                        _random == false && _categoryId == null,
                                    onPressed: () => _loadQuestion(_categoryId),
                                  ),
                                ),
                                SizedBox(
                                  height: _size.height * .05,
                                ),
                              ],
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _categories = Provider.of<Categories>(context, listen: false);

    void _chooseCategory({int categoryId, bool random = false}) {
      Navigator.of(context).pop(random ? random : categoryId);
    }

    return CustomPaint(
      painter: AnswerContainer(),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(50),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                "GIOCA",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 100),
                child: Container(
                  height: MediaQuery.of(context).size.height * .5,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (_, i) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      child: _categories.categories.asMap().containsKey(i)
                          ? Container(
                              child: CustomButton(
                                _categories.categories[i].name,
                                onPressed: () => _chooseCategory(
                                    categoryId: _categories.categories[i].id),
                                color: Theme.of(context).primaryColor,
                                icon: Icons.add,
                              ),
                            )
                          : CustomButton(
                              "Casuale",
                              icon: Icons.add,
                              color: Theme.of(context).primaryColor,
                              onPressed: () => _chooseCategory(random: true),
                            ),
                    ),
                    itemCount: _categories.categories.length + 1,
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 45.0),
          child: FloatingActionButton(
            splashColor: Colors.transparent,
            elevation: 5,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
