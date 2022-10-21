import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exceptions.dart';

import './product_model.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p7',
    //     title: 'A Hat',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://5.imimg.com/data5/QS/XK/MY-11393529/cotton-girls-cap-500x500.jpg')
  ];

  List<Product> get allItems {
    return [..._items];
  }

  Future<void> fetchAndSetData() async {
    final myUrl = Uri.parse(
        'https://shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app/products.json');

    try {
      final response = await http.get(myUrl);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedData = [];
      extractedData.forEach((prodId, prodData) {
        loadedData.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
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
    final myUrl = Uri.parse(
        'https://shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.post(myUrl,
          body: json.encode(
            {
              'title': p.title,
              'description': p.description,
              'price': p.price,
              'imageUrl': p.imageUrl,
              'isFavorite': p.isFavorite,
            },
          ));
      final newProd = Product(
          id: json.decode(response.body)['name'],
          title: p.title,
          description: p.description,
          price: p.price,
          imageUrl: p.imageUrl);
      _items.add(newProd);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product p) async {
    var index = _items.indexWhere((prod) => prod.id == p.id);
    if (index > 0) {
      final myUrl = Uri.parse(
          'https://shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app/products/${p.id}.json');
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
    final myUrl = Uri.parse(
        'https://shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
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
