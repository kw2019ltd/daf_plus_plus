import 'package:flutter/material.dart';

class DafWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Checkbox(
          onChanged: (state) {},
          value: false,
        ),
        title: Text("דף יא."),
      ),
    );
  }
}