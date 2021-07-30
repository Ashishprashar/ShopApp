import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/helper/custom_route.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/screen/orders_screen.dart';
import 'package:shopapp/screen/user-product-screen.dart';

class AppDrawer extends StatelessWidget {
  // const AppDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello User!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text("shop"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text("orders"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    CustomeRoute(builder: (ctx) => OrdersScreen()));
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text("user products"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    CustomeRoute(builder: (ctx) => UserProductScreen()));
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log Out"),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }
}
