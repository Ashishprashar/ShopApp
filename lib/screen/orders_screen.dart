import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/app-drawer.dart';
import 'package:shopapp/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders-screen";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchOrders();
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) {
                return OrderItems(orders[i]);
              },
              itemCount: orders.length,
            ),
    );
  }
}
