import 'package:daf_counter/widgets/gemara.dart';
import 'package:flutter/material.dart';

class ListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: [
        GemaraWidget(),
        GemaraWidget(),
        GemaraWidget(),
        GemaraWidget(),
      ],
    );
  }
}