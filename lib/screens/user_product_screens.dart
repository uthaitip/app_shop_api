import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../model/product.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';
  const UserProductScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: [
            IconButton(
                onPressed: () {},
                icon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName);
                  },
                ))
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: ((context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: ((context, productData, _) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                itemCount: productData.items.length,
                                itemBuilder: (_, index) => Column(
                                      children: [
                                        UserProductItem(
                                          title: productData.items[index].title,
                                          imageUrl:
                                              productData.items[index].imageUrl,
                                          id: productData.items[index].id,
                                        ),
                                        Divider(
                                          // color: Colors.amber,
                                          height: 20,
                                        ),
                                      ],
                                    )),
                          )),
                    )))));
  }
}
