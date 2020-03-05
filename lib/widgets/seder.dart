import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:daf_plus_plus/models/seder.dart';
import 'package:daf_plus_plus/utils/appLocalizations.dart';

class SederWidget extends StatelessWidget {
  SederWidget({@required this.seder});

  final SederModel seder;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      sticky: false,
      header: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(AppLocalizations.of(context).translate('seder') + " " + seder.name),
      ),
    );
  }
}
