import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final oldSatatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final myUrl = Uri.parse(
          'https://shop-app-bc977-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
      final response = await http.patch(myUrl,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavorite = oldSatatus;
        notifyListeners();
      }
      ;
    } catch (error) {
      isFavorite = oldSatatus;
      notifyListeners();
    }
  }
}
