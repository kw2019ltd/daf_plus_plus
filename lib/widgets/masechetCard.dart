import 'package:daf_counter/consts/consts.dart';
import 'package:daf_counter/models/dafLocation.dart';
import 'package:daf_counter/models/masechet.dart';
import 'package:daf_counter/services/hive/index.dart';
import 'package:daf_counter/utils/masechetConverter.dart';
import 'package:daf_counter/widgets/daf.dart';
import 'package:daf_counter/widgets/masechet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class MasechetCardWidget extends StatefulWidget {
  MasechetCardWidget({
    @required this.masechet,
    this.lastDafIndex = -1,
    this.hasTitle = true,
  });

  final MasechetModel masechet;
  final int lastDafIndex;
  final bool hasTitle;

  @override
  _MasechetCardWidgetState createState() => _MasechetCardWidgetState();
}

class _MasechetCardWidgetState extends State<MasechetCardWidget> {
  List<int> _progress = [];
  bool _isExpanded = false;
  double _progressInPecent = 0;

  void _onClickDaf(int dafIndex, int count) {
    _updateDafCount(dafIndex, count);
    _updateLastDaf(dafIndex);
  }

  void _updateLastDaf(int dafIndex) {
    DafLocationModel dafLocation =
        DafLocationModel(masechetId: widget.masechet.id, dafIndex: dafIndex);
    hiveService.settings.setLastDaf(dafLocation);
  }

  void _updateDafCount(int dafIndex, int count) {
    List<int> progress = _progress;
    progress[dafIndex] = count;
    String encodedProgress = masechetConverterUtil.encode(progress);
    hiveService.progress
        .setMasechetProgress(widget.masechet.id, encodedProgress);
    setState(() {
      _progress = progress;
      _progressInPecent = masechetConverterUtil.toPercent(progress);
    });
  }

  List<int> _generateNewProgress() => List.filled(widget.masechet.numOfDafs, 0);

  List<int> _getMasechetProgress() {
    String encodedProgress =
        hiveService.progress.getMasechetProgress(widget.masechet.id);
    return encodedProgress != null
        ? masechetConverterUtil.decode(encodedProgress)
        : _generateNewProgress();
  }

  void _onChangeExpandedState(bool state) {
    setState(() => _isExpanded = state);
  }

  @override
  void initState() {
    super.initState();
    List<int> progress = _getMasechetProgress();
    setState(() {
      _progress = progress;
      _progressInPecent = masechetConverterUtil.toPercent(progress);
      _isExpanded = widget.lastDafIndex != -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: widget.hasTitle
          ? MasechetWidget(
              masechetName: widget.masechet.name,
              isExpanded: _isExpanded,
              onChangeExpanded: _onChangeExpandedState,
              progressInPecent: _progressInPecent,
            )
          : Container(),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Container(
            height: Consts.MASECHET_LIST_HEIGHT,
            child: ScrollablePositionedList.builder(
              initialScrollIndex:
                  widget.lastDafIndex != -1 ? widget.lastDafIndex : 0,
              itemBuilder: (context, dafIndex) => DafWidget(
                dafNumber: dafIndex,
                dafCount: _progress[dafIndex],
                onChangeCount: (int count) => _onClickDaf(dafIndex, count),
              ),
              itemCount: widget.masechet.numOfDafs,
            ),
          ),
          childCount: _isExpanded ? 1 : 0,
        ),
      ),
    );
  }
}
