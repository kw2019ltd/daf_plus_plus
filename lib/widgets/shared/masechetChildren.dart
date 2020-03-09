import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/masechetConverter.dart';
import 'package:daf_plus_plus/widgets/shared/daf.dart';

class MasechetChildrenWidget extends StatefulWidget {
  MasechetChildrenWidget({
    @required this.masechet,
    this.lastDafIndex = -1,
    this.onProgressChange = _dontChangeProgress,
  });

  static dynamic _dontChangeProgress(List<int> progress) {}

  final MasechetModel masechet;
  final int lastDafIndex;
  final Function(List<int>) onProgressChange;

  @override
  _MasechetChildrenWidgetState createState() => _MasechetChildrenWidgetState();
}

class _MasechetChildrenWidgetState extends State<MasechetChildrenWidget> {
  List<int> _progress = [];
  List<String> _dates = [];
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

  List<String> _getMasechetDates() {
    return hiveService.dates.getMasechetDates(widget.masechet.id);
  }

  void _listenToUpdates() {
    _progressUpdates =
        hiveService.progress.listenToProgress(widget.masechet.id);
    _progressUpdates.listen((String updatedProgress) {
      List<int> progress = masechetConverterUtil.decode(updatedProgress);
      if (progress == null) progress = _generateNewProgress();
      setState(() => _progress = progress);
      widget.onProgressChange(_progress);
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
    List<String> dates = _getMasechetDates();
    setState(() {
      _progress = progress;
      _dates = dates;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onProgressChange(_progress);
    });
    _listenToUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      initialScrollIndex: widget.lastDafIndex != -1 ? widget.lastDafIndex : 0,
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
    );
  }
}
