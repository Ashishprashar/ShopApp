import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    required this.child,
    required this.value,
//  required this.color,
  });

  final child;
  final int value;
  //  final Color color;

  @override
  Widget build(BuildContext context) {
    print(value);
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).accentColor,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
