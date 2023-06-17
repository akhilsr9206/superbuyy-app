import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superbuyy/consts/firebase_consts.dart';

import '../models/month_model.dart';

class MonthlistProvider with ChangeNotifier {
  Map<String, MonthlistModel> _monthlistItems = {};

  Map<String, MonthlistModel> get getMonthlistItems {
    return _monthlistItems;
  }

  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchMonth() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    if (userDoc == null) {
      return;
    }
    final leng = userDoc.get('userMonth').length;
    for (int i = 0; i < leng; i++) {
      _monthlistItems.putIfAbsent(
          userDoc.get('userMonth')[i]['productId'],
          () => MonthlistModel(
                id: userDoc.get('userMonth')[i]['monthId'],
                productId: userDoc.get('userMonth')[i]['productId'],
                quantity: userDoc.get('userMonth')[i]['quantity'],
              ));
    }
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

  Future<void> removeOneItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userMonth': FieldValue.arrayRemove([
        {'monthId': cartId, 'productId': productId, 'quantity': quantity}
      ])
    });
    _monthlistItems.remove(productId);
    await fetchMonth();
    notifyListeners();
  }

  Future<void> clearOnlineMonth() async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userMonth': [],
    });
    _monthlistItems.clear();
    notifyListeners();
  }

  void clearLocalMonth() {
    _monthlistItems.clear();
    notifyListeners();
  }
}
