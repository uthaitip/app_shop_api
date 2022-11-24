import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/order_items.dart';
import '../providers/orders.dart' show Orders;

class OrderScreen extends StatefulWidget {
  // const OrderScreen(OrderItem order, {super.key});
  static const routerName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // Future _orderFuture() {
  //   return Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: const Text('Your Orders')),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (context, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (context, index) =>
                            OrderItems(order: orderData.orders[index])));
              }
            }
          },
        ));
  }
}
