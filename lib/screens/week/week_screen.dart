import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:superbuyy/screens/week/week_widget.dart';
import 'package:superbuyy/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

import '../../consts/firebase_consts.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/week_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';

class WeeklistScreen extends StatelessWidget {
  const WeeklistScreen({Key? key}) : super(key: key);
  static const routeName = "/WeeklistScreen";

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final weeklistProvider = Provider.of<WeeklistProvider>(context);
    final weeklistItemsList =
        weeklistProvider.getWeeklistItems.values.toList().reversed.toList();

    return weeklistItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your Weekly list is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/week.png',
          )
        : Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TextWidget(
                  text: 'Weekly list (${weeklistItemsList.length})',
                  color: Colors.green,
                  isTitle: true,
                  textSize: 22,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty your week list?',
                          subtitle: 'Are you sure?',
                          fct: () async {
                            await weeklistProvider.clearOnlinewWeek();
                            weeklistProvider.clearLocalWeek();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: Column(
              children: [
                _checkout(ctx: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: weeklistItemsList.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                          value: weeklistItemsList[index],
                          child: WeeklistWidget(
                            q: weeklistItemsList[index].quantity,
                          ));
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final weeklistProvider = Provider.of<WeeklistProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    num total = 0.0;
    weeklistProvider.getWeeklistItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                User? user = authInstance.currentUser;
                final productProvider =
                    Provider.of<ProductsProvider>(ctx, listen: false);
                weeklistProvider.getWeeklistItems.forEach((key, value) async {
                  final getCurrentProduct =
                      productProvider.findProdById(value.productId);

                  try {
                    final orderId = const Uuid().v4();

                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderId)
                        .set({
                      'orderId': orderId,
                      'userId': user!.uid,
                      'productId': value.productId,
                      'price': (getCurrentProduct.isOnSale
                              ? getCurrentProduct.salePrice
                              : getCurrentProduct.price) *
                          value.quantity,
                      'totalPrice': total,
                      'quantity': value.quantity,
                      'imageUrl': getCurrentProduct.imageUrl,
                      'userName': user.displayName,
                      'orderDate': Timestamp.now(),
                    });
                    //  await weeklistProvider.clearOnlinewWeek();
                    // weeklistProvider.clearLocalWeek();
                    ordersProvider.fetchOrders();
                    await Fluttertoast.showToast(
                      msg: "Your order has been placed",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  } catch (error) {
                    GlobalMethods.errorDialog(
                        subtitle: error.toString(), context: ctx);
                  } finally {}
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextWidget(
                  text: 'Order Now',
                  textSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          FittedBox(
            child: TextWidget(
              text: 'Total: \₹${total.toStringAsFixed(2)}',
              color: color,
              textSize: 18,
              isTitle: true,
            ),
          ),
        ]),
      ),
    );
  }
}
