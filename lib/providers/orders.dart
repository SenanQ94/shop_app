import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(
    this.authToken,
    this.userId,
    this._orders,
  );

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final myUrl = Uri.https(
        'shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app',
        'orders/$userId.json',
        {'auth': '$authToken'});
    // final myUrl = Uri.parse(
    //     'https://shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app/orders.json');

    try {
      final response = await http.get(myUrl);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      List<OrderItem> loadedData = [];
      if (extractedData == null) {
        _orders = loadedData.reversed.toList();
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedData.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                  imageUrl: item['imageUrl']))
              .toList(),
        ));
      });
      _orders = loadedData.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double amount) async {
    final myUrl = Uri.https(
        'shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app',
        'orders/$userId.json',
        {'auth': '$authToken'});
    // final myUrl = Uri.parse(
    //     'https://shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app/orders.json');
    final timestamp = DateTime.now();
    try {
      await http
          .post(myUrl,
              body: json.encode({
                'amount': amount,
                'dateTime': timestamp.toIso8601String(),
                'products': cartProducts
                    .map((cp) => {
                          'id': cp.id,
                          'title': cp.title,
                          'price': cp.price,
                          'quantity': cp.quantity,
                          'imageUrl': cp.imageUrl,
                        })
                    .toList(),
              }))
          .then((response) {
        _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            amount: amount,
            products: cartProducts,
            dateTime: DateTime.now(),
          ),
        );
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }
}
