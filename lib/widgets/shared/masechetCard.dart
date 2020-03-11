<<<<<<< HEAD
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
=======
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

>>>>>>> 81b43fa9bee8ddf9b00f0ca9e1b0aaea9f4a4769
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
<<<<<<< HEAD
  final int lastDafIndex;
  final bool hasTitle;
  final double listHeight;
=======
>>>>>>> 81b43fa9bee8ddf9b00f0ca9e1b0aaea9f4a4769

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
<<<<<<< HEAD
            height: widget.listHeight,
            child: ScrollablePositionedList.builder(
              initialScrollIndex:
                  widget.lastDafIndex != -1 ? widget.lastDafIndex : 0,
              itemBuilder: (context, dafIndex) => DafWidget(
                dafNumber: dafIndex,
                dafCount: _progress[dafIndex],
                dafDate: _dates != null &&
                        _dates.length > dafIndex &&
                        _dates[dafIndex] != null
                    ? _dates[dafIndex]
                    : "",
                onChangeCount: (int count) => _onClickDaf(dafIndex, count),
              ),
              itemCount: widget.masechet.numOfDafs,
            ),
          ),
=======
              height: Consts.MASECHET_LIST_HEIGHT,
              child: MasechetChildrenWidget(
                masechet: widget.masechet,
                onProgressChange: _updateProgress,
              )),
>>>>>>> 81b43fa9bee8ddf9b00f0ca9e1b0aaea9f4a4769
          childCount: _isExpanded ? 1 : 0,
        ),
      ),
    );
  }
}
