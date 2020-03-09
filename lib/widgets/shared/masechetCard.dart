import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/widgets/shared/masechet.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/masechetConverter.dart';
import 'package:daf_plus_plus/widgets/shared/masechetChildren.dart';

class MasechetCardWidget extends StatefulWidget {
  MasechetCardWidget({
    @required this.masechet,
  });

  final MasechetModel masechet;

  @override
  _MasechetCardWidgetState createState() => _MasechetCardWidgetState();
}

class _MasechetCardWidgetState extends State<MasechetCardWidget> {
  List<int> _progress = [];
  bool _isExpanded = false;

  void _onChangeExpandedState(bool state) {
    setState(() => _isExpanded = state);
  }

  void _updateProgress(List<int> progress) {
    setState(() => _progress = progress);
  }

  // TODO: the following two functions are duplicated in masechetCArd.dart, not ideal.
  List<int> _generateNewProgress() => List.filled(widget.masechet.numOfDafs, 0);

  List<int> _getMasechetProgress() {
    String encodedProgress =
        hiveService.progress.getMasechetProgress(widget.masechet.id);
    return encodedProgress != null
        ? masechetConverterUtil.decode(encodedProgress)
        : _generateNewProgress();
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
    _updateProgress(_getMasechetProgress());
  }

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: MasechetWidget(
        masechet: widget.masechet,
        isExpanded: _isExpanded,
        onChangeExpanded: _onChangeExpandedState,
        progress: _progress,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Container(
              height: Consts.MASECHET_LIST_HEIGHT,
              child: MasechetChildrenWidget(
                masechet: widget.masechet,
                onProgressChange: _updateProgress,
              )),
          childCount: _isExpanded ? 1 : 0,
        ),
      ),
    );
  }
}
