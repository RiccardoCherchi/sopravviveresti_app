import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class Products with ChangeNotifier {
  final _iap = InAppPurchaseConnection.instance;
  List<PurchaseDetails> _purchases;

  List<PurchaseDetails> get purchases {
    return [..._purchases];
  }

  Future<void> getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    _purchases = response.pastPurchases;
    _purchases.forEach((element) => print("buyed -> ${element.productID}"));
    notifyListeners();
  }
}
