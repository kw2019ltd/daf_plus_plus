import 'package:daf_counter/widgets/sectionTitle.dart';
import 'package:flutter/material.dart';

class RecentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionTitleWidget(title: "לומד היום",),
        Container(
          child: Text("this is the recent section"),
        ),
      ],
    );
  }
}
