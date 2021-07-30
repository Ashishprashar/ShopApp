import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;

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
//     // Product({
//       id: 'p2',
//       title: 'Trousers',
//       description: 'A nice pair of trousers.',
//       price: 59.99,
//       imageUrl:
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// }
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
  List<Product> get items {
    return [..._items];
  }

  var authToken;
  var userId;
  void update(String token, List<Product> item, String id) {
    _items = item;
    authToken = token;
    userId = id;
  }

  List<Product> get onlyFavoriteItems {
    // if (_showFavoriteOnly) {
    return _items.where((prod) => (prod.isFavorite)).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future deleteProduct(String id) async {
    try {
      final url =
          'https://flutter-project-ec6aa-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      final response = await http.delete(Uri.parse(url));
      _items.removeWhere((prd) {
        return prd.id == id;
      });
      notifyListeners();
    } catch (error) {}
  }

  Future<void> fetchAndSetProducts([bool filter = false]) async {
    final filterString = filter ? '&orderBy="userId"&equalTo="$userId"' : '';
    final url =
        'https://flutter-project-ec6aa-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      print(extractedData);
      final favresponse = await http.get(Uri.parse(
          "https://flutter-project-ec6aa-default-rtdb.firebaseio.com/userFavorites/$userId.json"));
      final favData = json.decode(favresponse.body);
      final List<Product> loadedData = [];
      extractedData.forEach((id, value) {
        loadedData.add(Product(
            id: id,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFavorite: favData == null ? false : favData[id] ?? false,
            imageUrl: value['imageUrl']));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print(error);
      // throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final url =
          'https://flutter-project-ec6aa-default-rtdb.firebaseio.com/products.json?auth=$authToken';
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'userId': userId,
            'title': product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          }));
      final newProducts = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProducts);
      // _items.insert(0,newProducts)
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    // .catchError((error) {
    // });
  }
  // Future<void> updateProduct(String id, Product product) async {

  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        final url =
            'https://flutter-project-ec6aa-default-rtdb.firebaseio.com/products/${id}.json?auth=$authToken';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': product.title,
              "description": product.description,
              "price": product.price,
              "imageUrl": product.imageUrl,
              "isFavorite": product.isFavorite,
            }));
      } catch (error) {}
      _items[prodIndex] = product;
      notifyListeners();
    }
  }
}
