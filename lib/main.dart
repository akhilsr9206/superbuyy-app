import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superbuyy/inner_screens/cat_screen.dart';
import 'package:superbuyy/inner_screens/on_sale_screen.dart';
import 'package:superbuyy/provider/dark_theme_provider.dart';
import 'package:superbuyy/providers/cart_provider.dart';
import 'package:superbuyy/providers/month_provider.dart';
import 'package:superbuyy/providers/products_provider.dart';
import 'package:superbuyy/providers/viewed_prod_provider.dart';
import 'package:superbuyy/providers/week_provider.dart';
import 'package:superbuyy/providers/wishlist_provider.dart';
import 'package:superbuyy/screens/btm_bar.dart';
import 'package:superbuyy/screens/lists.dart';
import 'package:superbuyy/screens/month/month_screen.dart';
import 'package:superbuyy/screens/viewed_recently/viewed_recently.dart';
import 'package:superbuyy/screens/week/week_screen.dart';

import 'consts/theme_data.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/product_details.dart';
import 'screens/auth/forget_pass.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ViewedProdProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MonthlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeeklistProvider(),
        ),
      ],
      child:
          Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'superbuy',
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            home: const BottomBarScreen(),
            routes: {
              OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
              FeedsScreen.routeName: (ctx) => const FeedsScreen(),
              ProductDetails.routeName: (ctx) => const ProductDetails(),
              WishlistScreen.routeName: (ctx) => const WishlistScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              ViewedRecentlyScreen.routeName: (ctx) =>
                  const ViewedRecentlyScreen(),
              RegisterScreen.routeName: (ctx) => const RegisterScreen(),
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              ForgetPasswordScreen.routeName: (ctx) =>
                  const ForgetPasswordScreen(),
              MonthlistScreen.routeName: (ctx) => const MonthlistScreen(),
              // ignore: equal_keys_in_map
              WeeklistScreen.routeName: (ctx) => const WeeklistScreen(),
              ListScreen.routeName: (ctx) => const ListScreen(),
              CategoryScreen.routeName: (ctx) => const CategoryScreen(),
            });
      }),
    );
  }
}
