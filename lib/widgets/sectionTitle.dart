import 'package:flutter/material.dart';

class SectionTitleWidget extends StatelessWidget {
  SectionTitleWidget({
    @required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: new BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0.0, 5),
          )
        ],
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
