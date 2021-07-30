import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/providers/orders.dart';

// import ''
class OrderItems extends StatefulWidget {
  final OrderItem order;

  OrderItems(this.order);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var expanded = false;
  @override
  Widget build(BuildContext context) {
    // final orderData=P
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expanded ? min(widget.order.products.length * 20 + 110, 200) : 95,
      child: Card(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                title: Text('\$${widget.order.amount}'),
                subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                    .format(widget.order.dateTime)),
                trailing: IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: expanded
                    ? min(widget.order.products.length * 20 + 10, 100)
                    : 0,
                child: ListView(
                  children: widget.order.products
                      .map((e) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${e.quantity}x \$${e.price}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ))
                      .toList(),
                ),
              )
            ],
          )),
    );
  }
}
