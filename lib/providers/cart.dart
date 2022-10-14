import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.values
        .fold(0, (quantity, cartItem) => cartItem.quantity + quantity);
  }

  int itemQuantity(String productID) {
    return _items[productID] != null ? _items[productID]!.quantity : 0;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  double get totalPrice {
    return _items.values.fold(
        0, (price, cartItem) => (cartItem.price * cartItem.quantity) + price);
  }

  bool isInCart(String productId) {
    if (_items.containsKey(productId)) {
      return true;
    }
    return false;
  }

  void addItem(String productId, String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  // void icnQuantity(String productId) {
  //   _items.update(
  //     productId,
  //     (existingCartItem) => CartItem(
  //         id: existingCartItem.id,
  //         title: existingCartItem.title,
  //         price: existingCartItem.price,
  //         quantity: existingCartItem.quantity + 1,
  //         imageUrl: existingCartItem.imageUrl),
  //   );
  // }

  void decQuantity(String productId) {
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity - 1,
            imageUrl: existingCartItem.imageUrl),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
