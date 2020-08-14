import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/question.dart';

import '../widgets/custom_button.dart';

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

    void _loadQuestion([int categoryId]) async {
      await _questions.getNewQuestion(categoryId);
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
              child: ScrollConfiguration(
                behavior: MyScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "GIOCA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 100),
                        child: Image.asset('assets/images/routePath.png'),
                      ),
                      Container(
                        width: double.infinity,
                        child: CustomPaint(
                            painter: AnswerContainer(),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 35),
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
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 32),
                                    child: Image.asset(
                                      'assets/images/categories.png',
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 32),
                                    child: CustomButton(
                                      "Gioca",
                                      disable: _random == false &&
                                          _categoryId == null,
                                      onPressed: () =>
                                          _loadQuestion(_categoryId),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      ClampingScrollPhysics();
}

class CategoryModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _categories = Provider.of<Categories>(context, listen: false);

    void _chooseCategory({int categoryId, bool random = false}) {
      Navigator.of(context).pop(random == true ? random : categoryId);
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
            splashColor: Colors.yellow[400],
            elevation: 5,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              size: 35,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
