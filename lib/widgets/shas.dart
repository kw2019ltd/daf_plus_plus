import 'package:daf_counter/data/shas.dart';
import 'package:daf_counter/models/gemara.dart';
import 'package:daf_counter/services/hive.dart';
import 'package:daf_counter/widgets/gemara.dart';
import 'package:flutter/material.dart';

class ShasWidget extends StatefulWidget {
  @override
  _ShasWidgetState createState() => _ShasWidgetState();
}

class _ShasWidgetState extends State<ShasWidget> {
  Widget _listOfGemaras() {
    return CustomScrollView(
      
      slivers: ShasData.THE_SHAS
          .map((GemaraModel gemara) => GemaraWidget(gemara: gemara))
          .toList(),
    );
  }

  @override
  void dispose() {
    hiveService.closeProgressBox();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: hiveService.openProgressBox(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          return _listOfGemaras();
        } else {
          return Container();
        }
      },
    );
  }
}
