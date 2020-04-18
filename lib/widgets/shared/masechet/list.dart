import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/daf.dart';

class MasechetListWidget extends StatefulWidget {
  MasechetListWidget({
    @required this.masechet,
    @required this.progress,
    this.lastDafIndex = -1,
    this.onProgressChange = _dontChangeProgress,
    this.hasPadding = false,
  });

  static dynamic _dontChangeProgress(ProgressModel progress) {}

  final MasechetModel masechet;
  final ProgressModel progress;
  final int lastDafIndex;
  final Function(ProgressModel) onProgressChange;
  final bool hasPadding;

  @override
  _MasechetListWidgetState createState() => _MasechetListWidgetState();
}

class _MasechetListWidgetState extends State<MasechetListWidget> {
  List<DateTime> _dates = [];

  void _onClickDaf(int daf, int count) {
    ProgressModel progress = widget.progress;
    progress.data[daf] = count;
    widget.onProgressChange(progress);
  }

  @override
  void initState() {
    super.initState();
    List<DateTime> dates =
        dafsDatesStore.getAllMasechetDates(widget.masechet.id);
    setState(() => _dates = dates);
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.progress?.data?.length ?? 0;
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
            dafCount: widget.progress.data[dafIndex],
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
