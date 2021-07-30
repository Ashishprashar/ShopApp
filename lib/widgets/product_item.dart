import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screen/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({required this.id, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context);
    final authData = Provider.of<Auth>(context);
    final cart = Provider.of<Cart>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            print("clicked");
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productData.id);
          },
          child: Hero(
            tag: productData.id,
            child: FadeInImage(
              placeholder: AssetImage('assests/images/product-placeholder.png'),
              image: NetworkImage(
                productData.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(product.isFavorite
                  ? (Icons.favorite)
                  : Icons.favorite_border),
              onPressed: () {
                product.toggleFavorite(authData.token, authData.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(
                    productData.id, productData.title, productData.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("added item to cart!"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleitem(productData.id);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor),
          backgroundColor: Colors.black87,
          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
