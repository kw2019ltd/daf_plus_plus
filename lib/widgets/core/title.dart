import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  TitleWidget({
    this.title,
    this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: title != null
            ? Text(
                this.title,
                style: Theme.of(context).textTheme.headline6,
              )
            : icon != null ? Icon(icon) : Container(),
      ),
    );
  }
}
