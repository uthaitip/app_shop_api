import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;
import 'package:shop_app/model/http_exception.dart';
import 'dart:convert';
import '../model/product.dart';
//ทุกที่ใน code สามารถเข้าถึง product

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _showFavoritesOnly = false;
  final String? authToken;
  final String? userId;

  Products(this.authToken, this._items, this.userId);

  //เพื่อเพิ่มรับ keyword และตั้งชื่อโดยไม่มีขีดล่าง
  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    // var _params = {
    //   'auth': authToken,
    // };
    print('aaaaaa');
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://appstore-659f7-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      url =
          'https://appstore-659f7-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach((productId, productData) {
        loadedProduct.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[productId] ?? false,
          imageUrl: productData['imageUrl'],
        ));
      });
      _items = loadedProduct;
      notifyListeners();
      // print(response.body);
      print(json.decode(response.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://appstore-659f7-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http
          .post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
          'creatorId': userId,
        }),
      )
          .then((response) {
        print(response);
        print(json.decode(response.body));
        final newProduct = Product(
          // id: DateTime.now().toString(),
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        );
        _items.add(newProduct);
        // _items.add(value);
        notifyListeners();
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  List<Product> get favoriteItem {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url =
          'https://appstore-659f7-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('......');
    }
  }
  //update in local
  // void updateProduct(String id, Product newProduct) {
  //   final productIndex = _items.indexWhere((element) => element.id == id);
  //   if (productIndex >= 0) {
  //     _items[productIndex] = newProduct;
  //   } else {
  //     print('......');
  //   }
  // }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://appstore-659f7-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existringProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final respone = await http.delete(Uri.parse(url));
    print(respone.statusCode);
    if (respone.statusCode >= 400) {
      throw HttpException('Could not delete Product!');
    }
    existringProduct = null;
  }
  //delete in local
  // void deleteProduct(String id) {
  //   _items.removeWhere((element) => element.id == id);
  //   notifyListeners();
  // }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
}
