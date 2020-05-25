import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final int i;

  PlaceholderWidget({this.i});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
              "Page "+ i.toString())
      ),
    );
  }
}
