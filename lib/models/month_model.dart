import 'package:flutter/material.dart';

class MonthlistModel with ChangeNotifier {
  final String id, productId;
  final int quantity;

  MonthlistModel(
      {required this.id, required this.productId, required this.quantity});
}
