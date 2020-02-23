import 'package:daf_counter/consts/consts.dart';
import 'package:daf_counter/models/dafLocation.dart';
import 'package:daf_counter/models/gemara.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/utils/gemaraConverter.dart';
import 'package:daf_counter/widgets/daf.dart';
import 'package:daf_counter/widgets/gemaraTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class GemaraWidget extends StatefulWidget {
  GemaraWidget({
    @required this.gemara,
    this.lastDafIndex,
  });

  final GemaraModel gemara;
  final int lastDafIndex;

  @override
  _GemaraWidgetState createState() => _GemaraWidgetState();
}

class _GemaraWidgetState extends State<GemaraWidget> {
  List<int> _progress = [];
  bool _isExpanded = false;
  double _progressInPecent = 0;

  void _onClickDaf(int dafIndex, int count) {
    _updateDafCount(dafIndex, count);
    _updateLastDaf(dafIndex);
  }

  void _updateLastDaf(int dafIndex) {
    DafLocationModel dafLocation =
        DafLocationModel(gemaraId: widget.gemara.id, dafIndex: dafIndex);
    hiveService.settings.setLastDaf(dafLocation);
  }

  void _updateDafCount(int dafIndex, int count) {
    List<int> progress = _progress;
    progress[dafIndex] = count;
    String encodedProgress = gemaraConverterUtil.encode(progress);
    hiveService.progress.setGemaraProgress(widget.gemara.id, encodedProgress);
    setState(() {
      _progress = progress;
      _progressInPecent = gemaraConverterUtil.toPercent(progress);
    });
  }

  List<int> _generateNewProgress() => List.filled(widget.gemara.numOfDafs, 0);

  List<int> _getGemaraProgress() {
    String encodedProgress =
        hiveService.progress.getGemaraProgress(widget.gemara.id);
    return encodedProgress != null
        ? gemaraConverterUtil.decode(encodedProgress)
        : _generateNewProgress();
  }

  void _onChangeExpandedState(bool state) {
    setState(() => _isExpanded = state);
  }

  @override
  void initState() {
    super.initState();
    List<int> progress = _getGemaraProgress();
    setState(() {
      _progress = progress;
      _progressInPecent = gemaraConverterUtil.toPercent(progress);
      _isExpanded = widget.lastDafIndex != -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: GemaraTitleWidget(
        gemaraName: widget.gemara.name,
        isExpanded: _isExpanded,
        onChangeExpanded: _onChangeExpandedState,
        progressInPecent: _progressInPecent,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Container(
            height: Consts.GEMARA_LIST_HEIGHT,
            child: ScrollablePositionedList.builder(
              initialScrollIndex:  widget.lastDafIndex != -1 ? widget.lastDafIndex : 0,
              itemBuilder: (context, dafIndex) => DafWidget(
                dafNumber: dafIndex,
                dafCount: _progress[dafIndex],
                onChangeCount: (int count) => _onClickDaf(dafIndex, count),
              ),
              itemCount: widget.gemara.numOfDafs,
            ),
          ),
          childCount: _isExpanded ? 1 : 0,
        ),
      ),
    );
  }
}
