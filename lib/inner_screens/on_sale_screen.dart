import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superbuyy/providers/products_provider.dart';
import 'package:superbuyy/services/utils.dart';
import 'package:superbuyy/widgets/back_widget.dart';
import 'package:superbuyy/widgets/empty_products_widget.dart';
import 'package:superbuyy/widgets/on_sale_widget.dart';
import 'package:superbuyy/widgets/text_widget.dart';

import '../models/products_model.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> productsOnSale = productsProviders.getOnSaleProducts;

    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;

    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Products on sale',
          color: color,
          textSize: 23.0,
          isTitle: true,
        ),
      ),
      body: productsOnSale.isEmpty
          ? const EmptyProdWidget(
              text: 'No products on sale yet!,\nStay tuned',
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              //crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.56),
              children: List.generate(productsOnSale.length, (index) {
                return ChangeNotifierProvider.value(
                  value: productsOnSale[index],
                  child: const OnSaleWidget(),
                );
              }),
            ),
    );
  }
}
