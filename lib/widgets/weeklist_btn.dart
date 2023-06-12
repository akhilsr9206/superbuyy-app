import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../providers/week_provider.dart';
import '../services/utils.dart';

class WEEKBTN extends StatelessWidget {
  const WEEKBTN(
      {Key? key,
      required this.productId,
      required this.quantity,
      this.isInWeeklist = false})
      : super(key: key);
  final String productId;
  final int quantity;
  final bool? isInWeeklist;

  @override
  Widget build(BuildContext context) {
    final weeklistProvider = Provider.of<WeeklistProvider>(context);

    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () {
        weeklistProvider.addProductsToWeeklist(
            productId: productId, quantity: quantity);
      },
      child: Column(
        children: [
          Icon(
            isInWeeklist != null && isInWeeklist == true
                ? IconlyBold.document
                : IconlyLight.document,
            size: 22,
            color: isInWeeklist != null && isInWeeklist == true
                ? Colors.green
                : color,
          ),
          Text(
            'Weekly List',
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }
}
