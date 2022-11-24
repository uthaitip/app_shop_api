import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/card.dart';
import 'package:shop_app/providers/products.dart';

import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';

class ProdcutItem extends StatelessWidget {
  // final String imageUrl;
  // final String id;
  // final String title;
  // const ProdcutItem(
  //     {super.key,
  //     required this.imageUrl,
  //     required this.id,
  //     required this.title});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                color: Theme.of(context).backgroundColor,
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoriteStatus(
                      authData.token!, authData.userId!);
                },
              ),
            ),
            title: Text(
              product.title,
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            trailing: IconButton(
              color: Theme.of(context).backgroundColor,
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Added item to cart!'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                            print('SnackBarAction');
                          })),
                );
                // Scaffold.of(context).bucket;
                // SnackBar(
                //   content: Text('aaa',style: TextStyle(color: Colors.amber),),
                // );
              },
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(
                  product.imageUrl,

                  // width: 200,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }
}
