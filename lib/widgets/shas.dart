import 'package:daf_counter/data/shas.dart';
import 'package:daf_counter/models/dafLocation.dart';
import 'package:daf_counter/models/gemara.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/widgets/gemara.dart';
import 'package:flutter/material.dart';

class ShasWidget extends StatefulWidget {
  @override
  _ShasWidgetState createState() => _ShasWidgetState();
}

class _ShasWidgetState extends State<ShasWidget> {
  Widget _listOfGemaras() {
    DafLocationModel lastDafLocation = hiveService.settings.getLastDaf();
    return CustomScrollView(
      slivers: ShasData.THE_SHAS
          .map((GemaraModel gemara) => GemaraWidget(
                gemara: gemara,
                lastDafIndex: gemara.id == lastDafLocation.gemaraId
                    ? lastDafLocation.dafIndex
                    : -1,
              ))
          .toList(),
    );
  }

  Future<void> _openBoxes() async {
    await hiveService.settings.open();
    await hiveService.progress.open();
  }

  @override
  void dispose() {
    hiveService.settings.close();
    hiveService.progress.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _openBoxes(),
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
