import 'package:daf_plus_plus/stores/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/widgets/shared/masechet.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/widgets/shared/masechetChildren.dart';
import 'package:provider/provider.dart';

class MasechetCardWidget extends StatefulWidget {
  MasechetCardWidget({
    @required this.masechet,
  });

  final MasechetModel masechet;

  @override
  _MasechetCardWidgetState createState() => _MasechetCardWidgetState();
}

class _MasechetCardWidgetState extends State<MasechetCardWidget> {
  bool _isExpanded = false;

  void _onChangeExpandedState(bool state) {
    setState(() => _isExpanded = state);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressStore progressStore = Provider.of<ProgressStore>(context, listen: false);
    return Observer(
      builder: (_) => SliverStickyHeader(
        header: MasechetWidget(
          masechet: widget.masechet,
          isExpanded: _isExpanded,
          onChangeExpanded: _onChangeExpandedState,
          progress: progressStore.getProgress(widget.masechet.id),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) => Container(
                height: Consts.MASECHET_LIST_HEIGHT,
                child: MasechetChildrenWidget(
                  masechet: widget.masechet,
                )),
            childCount: _isExpanded ? 1 : 0,
          ),
        ),
      ),
    );
  }
}
