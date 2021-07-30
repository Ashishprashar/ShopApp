import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';

class OrderButton extends StatefulWidget {
  final Cart cartData;
  const OrderButton(
    this.cartData,
  );

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.cartData.getPrice <= 0
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cartData.items.values.toList(),
                    widget.cartData.getPrice);
                widget.cartData.clear();
                setState(() {
                  isLoading = false;
                });
              },
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Text("Order Now"));
  }
}
