import 'package:daf_counter/widgets/daf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class GemaraWidget extends StatelessWidget {

  Widget _title() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      color: Colors.blue,
      child: Text("מסכת בבא קמא")
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: _title(),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => DafWidget(),
          childCount: 6,
        ),
      ),
    );
  }
}