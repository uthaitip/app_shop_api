import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/card.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> product;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.product,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;
  final String? userId;

  Orders(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    print('---------->userid $userId');
    final url =
        'https://appstore-659f7-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          product: cartProducts,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }

  Future<void> fetchAndSetOrder() async {
    final url =
        'https://appstore-659f7-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrder = [];
    print(json.decode(response.body));
    final extrctedData = await json.decode(response.body);

    if (extrctedData == null) {
      return;
    }

    extrctedData.forEach(((orderId, orderData) {
      loadedOrder.add(
        OrderItem(
            id: orderId,
            amount: orderData['amount'],
            product: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(
              orderData['dateTime'],
            )),
      );
    }));
    _orders = loadedOrder.reversed.toList();
    notifyListeners();
    print(json.decode(response.body));
  }

  // void addOrder(List<CartItem> cartProducts, double total) {
  //   _orders.insert(
  //       0,
  //       OrderItem(
  //         id: DateTime.now().toString(),
  //         amount: total,
  //         product: cartProducts,
  //         dateTime: DateTime.now(),
  //       ));
  //   notifyListeners();
  // }
}
