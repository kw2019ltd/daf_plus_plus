import 'package:flutter/material.dart';

class SectionHeaderWidget extends StatelessWidget {
  SectionHeaderWidget({@required this.header});

  final String header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(this.header),
    );
  }
}
