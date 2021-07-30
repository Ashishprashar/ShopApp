import 'dart:convert';

import 'package:flutter/Material.dart';
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
  void toggleFavorite(String token, String userId) async {
    final url =
        'https://flutter-project-ec6aa-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    isFavorite = !isFavorite;
    await http.put(Uri.parse(url), body: json.encode(isFavorite));

    notifyListeners();
  }
}
