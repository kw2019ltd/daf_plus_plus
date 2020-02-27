import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  TitleWidget({
    @required this.title,
    this.borderRadius = BorderRadius.zero,
    this.hasShadow = true,
  });

  final String title;
  final BorderRadius borderRadius;
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: new BoxDecoration(
        borderRadius: this.borderRadius,
        color: Theme.of(context).canvasColor,
        boxShadow: hasShadow ? [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0.0, 5),
          )
        ] : [],
      ),
      child: Center(
        child: Text(
          this.title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}