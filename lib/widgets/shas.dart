import 'package:daf_counter/data/masechets.dart';
import 'package:daf_counter/data/seders.dart';
import 'package:daf_counter/models/dafLocation.dart';
import 'package:daf_counter/models/masechet.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/widgets/masechetCard.dart';
import 'package:daf_counter/widgets/sectionTitle.dart';
import 'package:daf_counter/widgets/seder.dart';
import 'package:flutter/material.dart';

class ShasWidget extends StatefulWidget {
  @override
  _ShasWidgetState createState() => _ShasWidgetState();
}

class _ShasWidgetState extends State<ShasWidget> {
  List<Widget> _generateList() {
    DafLocationModel lastDafLocation = hiveService.settings.getLastDaf();
    int prevSederId = -1;
    List<Widget> list = [];
    MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) {
      if (prevSederId != masechet.sederId) {
        list.add(SederWidget(
          seder: SedersData.THE_SEDERS[masechet.sederId],
        ));
        prevSederId = masechet.sederId;
      }
      list.add(
        MasechetCardWidget(
          masechet: masechet,
          lastDafIndex: masechet.id == lastDafLocation.masechetId
              ? lastDafLocation.dafIndex
              : -1,
        ),
      );
    });
    return list;
  }

  Widget _listOfMasechets() {
    return CustomScrollView(
      slivers: _generateList(),
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
    return Column(
      children: <Widget>[
        SectionTitleWidget(
          title: "כל השס",
        ),
        Expanded(
          child: FutureBuilder(
            future: _openBoxes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) return Text(snapshot.error.toString());
                return _listOfMasechets();
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}
