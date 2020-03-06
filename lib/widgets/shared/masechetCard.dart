import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/masechetConverter.dart';
import 'package:daf_plus_plus/widgets/shared/daf.dart';
import 'package:daf_plus_plus/widgets/shared/masechet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class MasechetCardWidget extends StatefulWidget {
  MasechetCardWidget({
    @required this.masechet,
    this.lastDafIndex = -1,
    this.hasTitle = true,
    this.listHeight = Consts.MASECHET_LIST_HEIGHT,
  });

  final MasechetModel masechet;
  final int lastDafIndex;
  final bool hasTitle;
  final double listHeight;

  @override
  _MasechetCardWidgetState createState() => _MasechetCardWidgetState();
}

class _MasechetCardWidgetState extends State<MasechetCardWidget> {
  List<int> _progress = [];
  bool _isExpanded = false;
  Stream<String> _progressUpdates;

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

  void _listenToUpdates() {
    _progressUpdates =
        hiveService.progress.listenToProgress(widget.masechet.id);
    _progressUpdates.listen((String updatedProgress) {
      List<int> progress = masechetConverterUtil.decode(updatedProgress);
      if (progress == null) progress = _generateNewProgress();
      setState(() => _progress = progress);
    });
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
    List<int> progress = _getMasechetProgress();
    setState(() {
      _progress = progress;
      _isExpanded = widget.lastDafIndex != -1;
    });
    _listenToUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: widget.hasTitle
          ? MasechetWidget(
              masechet: widget.masechet,
              isExpanded: _isExpanded,
              onChangeExpanded: _onChangeExpandedState,
              progress: _progress,
            )
          : Container(),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Container(
            height: widget.listHeight,
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
