import 'package:daf_counter/data/shas.dart';
import 'package:daf_counter/models/dafLocation.dart';
import 'package:daf_counter/models/masechet.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/widgets/masechet.dart';
import 'package:flutter/material.dart';

class ShasWidget extends StatefulWidget {
  @override
  _ShasWidgetState createState() => _ShasWidgetState();
}

class _ShasWidgetState extends State<ShasWidget> {
  Widget _listOfMasechets() {
    DafLocationModel lastDafLocation = hiveService.settings.getLastDaf();
    return CustomScrollView(
      slivers: ShasData.THE_SHAS
          .map((MasechetModel masechet) => MasechetWidget(
                masechet: masechet,
                lastDafIndex: masechet.id == lastDafLocation.masechetId
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
          return _listOfMasechets();
        } else {
          return Container();
        }
      },
    );
  }
}
