import 'package:flutter/material.dart';

import '../models/week_model.dart';

class WeeklistProvider with ChangeNotifier {
  Map<String, WeeklistModel> _weeklistItems = {};

  Map<String, WeeklistModel> get getWeeklistItems {
    return _weeklistItems;
  }

  void addProductsToWeeklist({
    required String productId,
    required int quantity,
  }) {
    _weeklistItems.putIfAbsent(
      productId,
      () => WeeklistModel(
        id: DateTime.now().toString(),
        productId: productId,
        quantity: quantity,
      ),
    );
    notifyListeners();
  }

  void reduceQuantityByOne(String productId) {
    _weeklistItems.update(
      productId,
      (value) => WeeklistModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity - 1,
      ),
    );
    notifyListeners();
  }

  void increaseQuantityByOne(String productId) {
    _weeklistItems.update(
      productId,
      (value) => WeeklistModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity + 1,
      ),
    );
    notifyListeners();
  }

  void removeOneItem(String productId) {
    _weeklistItems.remove(productId);
    notifyListeners();
  }

  void clearWeeklist() {
    _weeklistItems.clear();
    notifyListeners();
  }
}
