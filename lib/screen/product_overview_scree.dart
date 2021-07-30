import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screen/cart_screen.dart';
import 'package:shopapp/widgets/app-drawer.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/product-grid.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  // final List<Product> loadedProducts ;
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

bool _showOnlyFav = false;

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorite"),
                value: FilterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text("ShowAll"),
                value: FilterOption.All,
              ),
            ],
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorite) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.itemCount(),
              child: ch,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFav),
    );
  }
}
