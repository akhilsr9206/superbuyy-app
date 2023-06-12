import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:superbuyy/inner_screens/feeds_screen.dart';
import 'package:superbuyy/services/global_methods.dart';
import 'package:superbuyy/services/utils.dart';
import 'package:superbuyy/widgets/feed_items.dart';
import 'package:superbuyy/widgets/on_sale_widget.dart';
import 'package:superbuyy/widgets/text_widget.dart';

import '../inner_screens/on_sale_screen.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _offerImages = [
    'assets/images/offers/Offer1.jpg',
    'assets/images/offers/Offer2.jpg',
    'assets/images/offers/Offer3.jpg',
    'assets/images/offers/Offer4.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    final Color color = Utils(context).color;
    Size size = utils.getScreenSize;
    final productsProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProviders.getProducts;
    List<ProductModel> productsOnSale = productsProviders.getOnSaleProducts;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.33,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      _offerImages[index],
                      fit: BoxFit.fill,
                    );
                  },
                  autoplay: true,
                  itemCount: _offerImages.length,
                  pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white,
                      activeColor: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextButton(
                onPressed: () {
                  GlobalMethods.navigateTo(
                    ctx: context,
                    routeName: OnSaleScreen.routeName,
                  );
                },
                child: TextWidget(
                  text: 'View all',
                  maxLines: 1,
                  color: Colors.blue,
                  textSize: 20,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  RotatedBox(
                    quarterTurns: -1,
                    child: Row(
                      children: [
                        TextWidget(
                          text: 'On sale'.toUpperCase(),
                          color: Colors.red,
                          textSize: 22,
                          isTitle: true,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          IconlyLight.discount,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: SizedBox(
                      height: size.height * 0.29,
                      child: ListView.builder(
                        itemCount: productsOnSale.length < 10
                            ? productsOnSale.length
                            : 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider.value(
                              value: productsOnSale[index],
                              child: const OnSaleWidget());
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Our Products',
                      color: color,
                      textSize: 22,
                      isTitle: true,
                    ),
                    TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: FeedsScreen.routeName,
                        );
                      },
                      child: TextWidget(
                        text: 'Browse all',
                        maxLines: 1,
                        color: Colors.blue,
                        textSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                childAspectRatio: size.width / (size.height * 0.59),
                children: List.generate(
                    allProducts.length < 4 ? allProducts.length : 4, (index) {
                  return ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child: const FeedsWidget(),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(bottom: 22),
                child: const Row(
                    // Add to Cart section
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
