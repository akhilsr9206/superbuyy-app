import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../providers/month_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';

class MONBTN extends StatelessWidget {
  const MONBTN(
      {Key? key,
      required this.productId,
      required this.quantity,
      this.isInMonthlist = false})
      : super(key: key);
  final String productId;
  final int quantity;
  final bool? isInMonthlist;

  @override
  Widget build(BuildContext context) {
    final monthlistProvider = Provider.of<MonthlistProvider>(context);

    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () async {
        try {
          final User? user = authInstance.currentUser;

          if (user == null) {
            GlobalMethods.errorDialog(
                subtitle: 'No user found,Please login first', context: context);
            return;
          }
          if (isInMonthlist == false && isInMonthlist != null) {
            GlobalMethods.addToMonth(
                productId: productId, quantity: quantity, context: context);
            await monthlistProvider.fetchMonth();
          }
        } catch (error) {
        } finally {}
        //  monthlistProvider.addProductsToMonthlist(
        //     productId: productId, quantity: quantity);
      },
      child: Column(
        children: [
          Icon(
            isInMonthlist != null && isInMonthlist == true
                ? IconlyBold.document
                : IconlyLight.document,
            size: 22,
            color: isInMonthlist != null && isInMonthlist == true
                ? Colors.green
                : color,
          ),
          Text(
            'Monthly List',
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }
}
