import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  int quantity;
  double price;

  CartItem({
    required this.id,
    required this.title,
    this.quantity = 1,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  late Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int itemCount() {
    // if (_items.isEmpty) {
    //   print(0);
    //   return 0;
    // } else {
    //   print(_items.length);
    //   return _items.length;
    // }
    try {
      return _items.length;
    } catch (E) {
      return 0;
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  removeSingleitem(String key) {
    if (!_items.containsKey(key)) {
      return;
    }
    if (_items[key]!.quantity > 1) {
      _items.update(
          key,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity - 1));
    } else {
      removeItem(key);
    }
    notifyListeners();
  }

  double get getPrice {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(), title: title, price: price));
    }
    notifyListeners();
  }
}
