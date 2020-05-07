
import 'package:flutter/material.dart';

class SpacerWidget extends StatelessWidget {
  const SpacerWidget({
    this.width = 0,
    this.height = 0,
    Key key,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
    );
  }
}
