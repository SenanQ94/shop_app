import 'package:flutter/material.dart';

import './product_model.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p3',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Headphones',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://cdn.shopify.com/s/files/1/0573/2309/4216/products/LosAngeles_SandGold_001_1200x1200.png?v=1650876856',
    ),
    Product(
      id: 'p5',
      title: 'boots',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSH37CmlD8_8_lN0e_INW7MpoMp-KnE5sptwH1ps-UKRpTCZkmnssiJOjb5UTbv1hMEccg&usqp=CAU',
    ),
    Product(
        id: 'p7',
        title: 'A Hat',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl:
            'https://5.imimg.com/data5/QS/XK/MY-11393529/cotton-girls-cap-500x500.jpg')
  ];

  // var _showFavoritesOnly = false;
  //   void showFavsOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  List<Product> get allItems {
    // if (_showFavoritesOnly) {
    //   return _items.where((p) => p.isFavorite).toList();
    // }
    return [..._items];
  }

  void addProduct(Product p) {
    _items.add(p);
    notifyListeners();
  }

  void updateProduct(Product p) {
    var index = _items.indexWhere((prod) => prod.id == p.id);
    if (index > 0) {
      _items[index] = p;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  List<Product> get favoriteItems {
    return _items.where((p) => p.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
