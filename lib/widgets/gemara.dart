import 'dart:math';

import 'package:daf_counter/consts/shas.dart';
import 'package:daf_counter/models/gemara.dart';
import 'package:daf_counter/services/hive.dart';
import 'package:daf_counter/utils/gemaraConverter.dart';
import 'package:daf_counter/widgets/daf.dart';
import 'package:daf_counter/widgets/gemaraTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class GemaraWidget extends StatefulWidget {
  GemaraWidget({
    @required this.gemara,
  });

  final GemaraModel gemara;

  @override
  _GemaraWidgetState createState() => _GemaraWidgetState();
}

class _GemaraWidgetState extends State<GemaraWidget> {
  List<int> _progress = [];
  bool _isExpanded = false;
  double _progressInPecent = 0;

  void _updateDafCount(int dafIndex, int count) {
    List<int> progress = _progress;
    progress[dafIndex] = count;
    String encodedProgress = gemaraConverterUtil.encode(progress);
    hiveService.setGemaraProgress(widget.gemara.id, encodedProgress);
    setState(() {
      _progress = progress;
      _progressInPecent = gemaraConverterUtil.toPercent(progress);
    });
  }

  List<int> _generateNewProgress() => List.filled(widget.gemara.numOfDafs, 0);

  List<int> _getGemaraProgress() {
    String encodedProgress = hiveService.getGemaraProgress(widget.gemara.id);
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
          (context, dafIndex) => DafWidget(
              dafNumber: dafIndex,
              dafCount: _progress[dafIndex],
              onChangeCount: (int count) => _updateDafCount(dafIndex, count)),
          childCount: _isExpanded ? widget.gemara.numOfDafs : 0,
        ),
      ),
    );
  }
}
