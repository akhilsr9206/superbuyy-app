import 'package:flutter/material.dart';

class WeeklistModel with ChangeNotifier {
  final String id, productId;
  final int quantity;

  WeeklistModel(
      {required this.id, required this.productId, required this.quantity});
}
