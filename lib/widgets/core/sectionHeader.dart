import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class SectionHeaderWidget extends StatelessWidget {
  SectionHeaderWidget({@required this.header});

  final String header;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      sticky: false,
      header: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(this.header),
      ),
    );
  }
}
