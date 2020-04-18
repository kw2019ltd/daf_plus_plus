import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/stores/progress.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/list.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/title.dart';

class MasechetWidget extends StatefulWidget {
  MasechetWidget({
    @required this.masechetId,
  });

  final String masechetId;

  @override
  _MasechetWidgetState createState() => _MasechetWidgetState();
}

class _MasechetWidgetState extends State<MasechetWidget> {
  bool _isExpanded = false;

  void _onChangeExpandedState(bool state) {
    setState(() => _isExpanded = state);
  }

  void _onProgressChange(ProgressModel progress) {
    progressAction.update(widget.masechetId, progress);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _masechetTitle(MasechetModel masechet, ProgressModel progress) {
    return MasechetTitleWidget(
      masechet: masechet,
      progress: progress,
      isExpanded: _isExpanded,
      onChangeExpanded: _onChangeExpandedState,
    );
  }

  SliverList _masechetList(MasechetModel masechet, ProgressModel progress) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, _) => Container(
            height: Consts.MASECHET_LIST_HEIGHT,
            child: MasechetListWidget(
              masechet: masechet,
              progress: progress,
              onProgressChange: _onProgressChange,
            )),
        childCount: _isExpanded ? 1 : 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BuildContext progressContext = progressAction.getProgressContext();
    return Observer(builder: (context) {
      ProgressStore progressStore = Provider.of<ProgressStore>(progressContext);
      ProgressModel progress = progressStore.getProgressMap[widget.masechetId];
      MasechetModel masechet = MasechetsData.THE_MASECHETS[widget.masechetId];
      return SliverStickyHeader(
        header: _masechetTitle(masechet, progress),
        sliver: _masechetList(masechet, progress),
      );
    });
  }
}
