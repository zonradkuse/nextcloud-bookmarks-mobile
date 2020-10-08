import 'package:flutter/material.dart';

class CenteredCard extends StatelessWidget {
  CenteredCard({@required this.child, this.padding = const EdgeInsets.all(20.0)});

  final Widget child;

  final EdgeInsetsGeometry padding;

  Widget build(BuildContext build) {
    return
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Card(
                child: Container(
                    padding: padding,
                    child: child
                ),
              ),
            ),
          ]
      );
  }
}