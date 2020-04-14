import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/widgets/shared/daf.dart';

class MasechetChildrenWidget extends StatefulWidget {
  MasechetChildrenWidget({
    @required this.masechet,
    this.lastDafIndex = -1,
    this.onProgressChange = _dontChangeProgress,
    this.hasPadding = false,
  });

  static dynamic _dontChangeProgress(ProgressModel progress) {}

  final MasechetModel masechet;
  final int lastDafIndex;
  final Function(ProgressModel) onProgressChange;
  final bool hasPadding;

  @override
  _MasechetChildrenWidgetState createState() => _MasechetChildrenWidgetState();
}

class _MasechetChildrenWidgetState extends State<MasechetChildrenWidget> {
  ProgressModel _progress = ProgressModel.empty(0);
  List<DateTime> _dates = [];
  // Stream<ProgressModel> _progressUpdates;

  void _onClickDaf(int dafIndex, int count) {
    _updateDafCount(dafIndex, count);
    _updateLastDaf(dafIndex);
  }

  void _updateLastDaf(int dafIndex) {
    DafModel daf = DafModel(masechetId: widget.masechet.id, number: dafIndex);
    hiveService.settings.setLastDaf(daf);
  }

  void _updateDafCount(int dafIndex, int count) {
    ProgressModel progress = _progress ?? ProgressModel.empty(widget.masechet.numOfDafs);
    progress.data[dafIndex] = count;
    progressAction.update(context, widget.masechet.id, progress);
  }

  // ProgressModel _generateNewProgress() => ProgressModel.empty(widget.masechet.numOfDafs);

  ProgressModel _getMasechetProgress() {
    ProgressModel progress =
        hiveService.progress.getProgress(widget.masechet.id);
    return progress;
    // return encodedProgress != null
    //     ? masechetConverterUtil.decode(encodedProgress)
    //     : _generateNewProgress();
  }

  // void _listenToUpdates() {
  //   _progressUpdates =
  //       hiveService.progress.listenToProgress(widget.masechet.id);
  //   _progressUpdates.listen((ProgressModel updatedProgress) {
  //     setState(() => _progress = updatedProgress);
  //     widget.onProgressChange(_progress);
  //   });
  // }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    // ProgressModel progress = _getMasechetProgress();
    // ProgressModel progress = P
    List<DateTime> dates =
        dafsDatesStore.getAllMasechetDates(widget.masechet.id);
    setState(() {
      // _progress = progress;
      _dates = dates;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onProgressChange(_progress);
      ProgressModel progress = progressAction.get(context, widget.masechet.id);
      print(progress);
      setState(() => _progress = progress);
    });
    // _listenToUpdates();
  }

  @override
  Widget build(BuildContext context) {
    int count = _progress.data.length;
    count = widget.hasPadding ? count + 1 : count;
    return Scrollbar(
      child: ScrollablePositionedList.builder(
        initialScrollIndex: widget.lastDafIndex != -1 ? widget.lastDafIndex : 0,
        itemCount: count,
        itemBuilder: (context, dafIndex) {
          if (widget.hasPadding && count == dafIndex + 1)
            return Container(height: 100);
          return DafWidget(
            dafNumber: dafIndex,
            dafCount: _progress.data[dafIndex],
            dafDate: _dates != null &&
                    _dates.length > dafIndex &&
                    _dates[dafIndex] != null
                ? _dates[dafIndex]
                : "",
            onChangeCount: (int count) => _onClickDaf(dafIndex, count),
          );
        },
      ),
    );
  }
}
