import 'package:flutter/material.dart';

import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/masechet.dart';

class TodaysDafPage extends StatelessWidget {
  Widget _openList(BuildContext context, DafModel daf) {
    return CustomScrollView(slivers: [
      MasechetWidget(
        masechetAndDaf: daf,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    DafModel daf = hiveService.settings.getLastDaf();

    return _openList(context, daf);
  }
}
