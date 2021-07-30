import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/cart_item.dart';
import 'package:shopapp/widgets/order-button.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Chip(
                    label: Text("\$${cartData.getPrice}"),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderButton(cartData),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItems(
                id: cartData.items.values.toList()[i].id,
                productId: cartData.items.keys.toList()[i],
                title: cartData.items.values.toList()[i].title,
                price: cartData.items.values.toList()[i].price,
                quantity: cartData.items.values.toList()[i].quantity,
              ),
              itemCount: cartData.itemCount(),
            ),
          )
        ],
      ),
    );
  }
}
