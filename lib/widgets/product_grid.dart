import 'package:flutter/material.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/providers/products.dart';

import 'product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid({super.key, required this.showFavs});
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavs ? productData.favoriteItem : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), //ช่วยในการจัดการgrid
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(
            // create: ((context) => products[index]),
            value: products[index],
            child: ProdcutItem(
                // imageUrl: products[index].imageUrl,
                // id: products[index].id,
                // title: products[index].title,
                ),
          )),
      itemCount: products.length,
    );
  }
}
