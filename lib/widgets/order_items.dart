import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as ord;
import 'package:intl/intl.dart';

import '../screens/cart_screen.dart';

class OrderItems extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItems({super.key, required this.order});

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          expanded ? min(widget.order.product.length * 20.0 + 110, 200) : 95,
      child: Card(
        child: Column(children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.green,
              ),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
                // Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          AnimatedContainer(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            height: expanded
                ? min(
                    widget.order.product.length * 20.0 + 10,
                    100,
                  )
                : 0,
            // color: Colors.green,
            duration: Duration(milliseconds: 300),
            child: ListView(children: [
              ...widget.order.product
                  .map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${e.quantity}x \$${e.price}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ))
                  .toList()
            ]),
          )
        ]),
      ),
    );
  }
}
