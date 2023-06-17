import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../consts/firebase_consts.dart';
import '../models/week_model.dart';

class WeeklistProvider with ChangeNotifier {
  Map<String, WeeklistModel> _weeklistItems = {};

  Map<String, WeeklistModel> get getWeeklistItems {
    return _weeklistItems;
  }

  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchWeek() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    if (userDoc == null) {
      return;
    }
    final leng = userDoc.get('userWeek').length;
    for (int i = 0; i < leng; i++) {
      _weeklistItems.putIfAbsent(
          userDoc.get('userWeek')[i]['productId'],
          () => WeeklistModel(
                id: userDoc.get('userWeek')[i]['weekId'],
                productId: userDoc.get('userWeek')[i]['productId'],
                quantity: userDoc.get('userWeek')[i]['quantity'],
              ));
    }
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

  Future<void> removeOneItem({
    required String weekId,
    required String productId,
    required int quantity,
  }) async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWeek': FieldValue.arrayRemove([
        {'weekId': weekId, 'productId': productId, 'quantity': quantity}
      ])
    });
    _weeklistItems.remove(productId);
    await fetchWeek();
    notifyListeners();
  }

  Future<void> clearOnlinewWeek() async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWeek': [],
    });
    _weeklistItems.clear();
    notifyListeners();
  }

  void clearLocalWeek() {
    _weeklistItems.clear();
    notifyListeners();
  }
}
