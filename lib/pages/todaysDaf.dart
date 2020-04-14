import 'package:flutter/material.dart';

import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/masechet.dart';

class TodaysDafPage extends StatelessWidget {
  Widget _openList(BuildContext context, MasechetModel masechet,
      DafModel daf) {
    return CustomScrollView(slivers: [MasechetWidget(
      masechetId: masechet.id,
    )]);
  }

  @override
  Widget build(BuildContext context) {
    DafModel daf = hiveService.settings.getLastDaf();
    MasechetModel masechet = MasechetsData.THE_MASECHETS[daf.masechetId];

    return _openList(context, masechet, daf);
  }
}
