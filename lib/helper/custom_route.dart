import 'package:flutter/material.dart';

class CustomeRoute<T> extends MaterialPageRoute<T> {
  CustomeRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransistionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // TODO: implement buildTransitions
// if(route.settings.)
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
