import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  var authToken;
  var userId;
  void update(String token, List<OrderItem> order, String id) {
    authToken = token;
    userId = id;
  }

  Future<void> fetchOrders() async {
    final url =
        'https://flutter-project-ec6aa-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // if (extractedData == null) return;
      print("extractedData" + extractedData.toString());
      final List<OrderItem> loadedData = [];
      extractedData.forEach((key, value) {
        loadedData.add(OrderItem(
            key,
            value['amount'],
            (value['products'] as List<dynamic>)
                .map((e) => CartItem(
                      id: e['id'],
                      title: e['title'],
                      price: e['price'],
                      quantity: e['quantity'],
                    ))
                .toList(),
            DateTime.parse(value['dateTime'])));
      });
      print(_orders);
      _orders = loadedData.reversed.toList();
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addOrder(List<CartItem> cartItem, double total) async {
    final timeStamp = DateTime.now().toIso8601String();
    final url =
        'https://flutter-project-ec6aa-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp,
          "products": cartItem
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
        OrderItem(json.decode(response.body)['name'], total, cartItem,
            DateTime.now()));
    notifyListeners();
  }
}
