import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/helper/custom_route.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screen/16.2%20splash_screen.dart';
import 'package:shopapp/screen/auth_screen.dart';
import 'package:shopapp/screen/cart_screen.dart';
import 'package:shopapp/screen/edit-produc-screen.dart';
import 'package:shopapp/screen/orders_screen.dart';
import 'package:shopapp/screen/product_detail_screen.dart';
import 'package:shopapp/screen/product_overview_scree.dart';
import 'package:shopapp/screen/user-product-screen.dart';

// import 'package:';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),

          // ChangeNotifierProvider(create: (_) => Products()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (ctx) => Products(),
              update: (ctx, auth, item) =>
                  // item != null
                  (item!..update(auth.token, item.items, auth.userId))
              // : (item!..update("", [],"")),
              ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (ctx) => Orders(),
              update: (ctx, auth, item) =>
                  (item!..update(auth.token, item.orders, auth.userId))),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato',
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransistionBuilder(),
                    TargetPlatform.iOS: CustomPageTransistionBuilder()
                  })),
              home: auth.isAuth
                  ? ProductOverViewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                // '/': (ctx) => Pr ductOverViewScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductScreen.routeName: (ctx) => UserProductScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
                AuthScreen.routeName: (ctx) => AuthScreen(),
              },
            );
          },
        ));
  }
}
