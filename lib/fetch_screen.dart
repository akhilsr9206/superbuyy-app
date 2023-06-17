import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:superbuyy/providers/cart_provider.dart';
import 'package:superbuyy/providers/month_provider.dart';
import 'package:superbuyy/providers/orders_provider.dart';
import 'package:superbuyy/providers/products_provider.dart';
import 'package:superbuyy/providers/week_provider.dart';
import 'package:superbuyy/providers/wishlist_provider.dart';
import 'package:superbuyy/screens/btm_bar.dart';

import 'consts/contss.dart';
import 'consts/firebase_consts.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String> images = Constss.authImagesPaths;
  @override
  void initState() {
    images.shuffle();

    Future.delayed(const Duration(microseconds: 5), () async {
      final productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final monthlistProvider =
          Provider.of<MonthlistProvider>(context, listen: false);
      final weeklistProvider =
          Provider.of<WeeklistProvider>(context, listen: false);
      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      final User? user = authInstance.currentUser;
      if (user == null) {
        await productsProvider.fetchProducts();
        cartProvider.clearLocalCart();
        monthlistProvider.clearLocalMonth();
        weeklistProvider.clearLocalWeek();
        wishlistProvider.clearLocalWishlist();
        ordersProvider.clearLocalOrders();
      } else {
        await productsProvider.fetchProducts();
        await cartProvider.fetchCart();
        await monthlistProvider.fetchMonth();
        await weeklistProvider.fetchWeek();
        await wishlistProvider.fetchWishlist();
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const BottomBarScreen(),
      ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            images[0],
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
            child: SpinKitFadingFour(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
