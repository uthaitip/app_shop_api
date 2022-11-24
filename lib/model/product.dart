import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  // id title description price imageUrl isFavorite
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  // final String userId;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    // required this.userId,
    this.isFavorite = false,
  });

  // set old status
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldValue = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://appstore-659f7-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final respone = await http.put(Uri.parse(url),
          body: json.encode(
            isFavorite,
          ));
      if (respone.statusCode >= 400) {
        _setFavValue(oldValue);
      }
    } catch (e) {
      _setFavValue(oldValue);
    }
  }

  //local
  // void toggleFavoriteStatus() {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  // }
}
