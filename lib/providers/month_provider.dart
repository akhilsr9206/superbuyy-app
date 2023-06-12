import 'package:flutter/material.dart';

import '../models/month_model.dart';

class MonthlistProvider with ChangeNotifier {
  Map<String, MonthlistModel> _monthlistItems = {};

  Map<String, MonthlistModel> get getMonthlistItems {
    return _monthlistItems;
  }

  void addProductsToMonthlist({
    required String productId,
    required int quantity,
  }) {
    _monthlistItems.putIfAbsent(
      productId,
      () => MonthlistModel(
        id: DateTime.now().toString(),
        productId: productId,
        quantity: quantity,
      ),
    );
    notifyListeners();
  }

  void reduceQuantityByOne(String productId) {
    _monthlistItems.update(
      productId,
      (value) => MonthlistModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity - 1,
      ),
    );
    notifyListeners();
  }

  void increaseQuantityByOne(String productId) {
    _monthlistItems.update(
      productId,
      (value) => MonthlistModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity + 1,
      ),
    );
    notifyListeners();
  }

  void removeOneItem(String productId) {
    _monthlistItems.remove(productId);
    notifyListeners();
  }

  void clearMonthlist() {
    _monthlistItems.clear();
    notifyListeners();
  }
}
