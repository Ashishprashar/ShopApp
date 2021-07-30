import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  // final List<Product> loadedProducts;
  final bool showOnlyFav;

  ProductsGrid(this.showOnlyFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products =
        showOnlyFav ? productData.onlyFavoriteItems : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // id: products[i].id,
            // title: products[i].title,
            // imageUrl: products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
    );
  }
}
