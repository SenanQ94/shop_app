import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exceptions.dart';

import './product_model.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String authToken;
  String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get allItems {
    return [..._items];
  }

  Future<void> fetchAndSetData([bool filterByUser = false]) async {
    final _params = filterByUser
        ? {
            'auth': '$authToken',
            "orderBy": json.encode("creatorId"),
            "equalTo": json.encode(userId),
          }
        : {'auth': '$authToken'};
    final myUrl = Uri.https(
        'shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json',
        _params);
    final url = Uri.https(
        'shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app',
        '/userFavorites/$userId.json',
        {'auth': '$authToken'});

    try {
      final response = await http.get(myUrl);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      List<Product> loadedData = [];
      extractedData.forEach((prodId, prodData) {
        loadedData.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product p) async {
    final myUrl = Uri.https(
        'shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json', {
      'auth': '$authToken',
    });

    try {
      final response = await http.post(myUrl,
          body: json.encode(
            {
              'title': p.title,
              'description': p.description,
              'price': p.price,
              'imageUrl': p.imageUrl,
              'creatorId': userId,
            },
          ));
      final newProd = Product(
        id: json.decode(response.body)['name'],
        title: p.title,
        description: p.description,
        price: p.price,
        imageUrl: p.imageUrl,
      );
      _items.add(newProd);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product p) async {
    var index = _items.indexWhere((prod) => prod.id == p.id);
    if (index > 0) {
      final myUrl = Uri.https(
          'shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app',
          '/products/${p.id}.json',
          {'auth': '$authToken'});
      // final myUrl = Uri.parse(
      //     'https://shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app/products/${p.id}.json');
      await http.patch(myUrl,
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'price': p.price,
            'imageUrl': p.imageUrl,
            'isFavorite': p.isFavorite,
          }));
      _items[index] = p;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final myUrl = Uri.https(
        'shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/${id}.json',
        {'auth': '$authToken'});
    // final myUrl = Uri.parse(
    //     'https://shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    final excitingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? exictingProduct = _items[excitingProductIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();

    final response = await http.delete(myUrl);

    if (response.statusCode >= 400) {
      _items.insert(excitingProductIndex, exictingProduct);
      notifyListeners();
      throw HttpException('we could not delete the item!');
    }
    exictingProduct = null;
  }

  List<Product> get favoriteItems {
    return _items.where((p) => p.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
