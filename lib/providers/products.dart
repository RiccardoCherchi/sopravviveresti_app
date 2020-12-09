import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../helpers/db.dart';

class Products with ChangeNotifier {
  final _iap = InAppPurchaseConnection.instance;

  Future<void> getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    final _pastPurchases = response.pastPurchases;
    _pastPurchases.forEach((element) async {
      print("buyed -> ${element.productID}");
      await addNewProduct(element.productID);
      print(await getLocalPurchases());
    });
  }

  Future<void> addNewProduct(String id) async {
    print("new local purchase: $id");
    await DB.insert(
      "purchases",
      {
        "product_id": id,
      },
    );
  }

  Future<List<String>> getLocalPurchases() async {
    final data = await DB.getData("purchases");
    List<String> _purchases = [];
    data.forEach((element) {
      _purchases.add(element['product_id']);
    });
    return _purchases;
  }
}
