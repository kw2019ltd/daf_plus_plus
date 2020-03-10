import 'package:flutter/material.dart';

import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';

class InfoDialogWidget extends StatelessWidget {
  InfoDialogWidget({
    @required this.title,
    @required this.text,
    @required this.actionText,
  });

  final String title;
  final String text;
  final String actionText;

  Widget _actionSection(BuildContext context) {
    return ButtonWidget(
      onPressed: () => Navigator.pop(context, true),
      text: this.actionText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      margin: EdgeInsets.symmetric(horizontal: 64, vertical: 124),
      onTapBackground: () => Navigator.pop(context, false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TitleWidget(
            title: this.title,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Text(this.text),
          ),
          _actionSection(context),
        ],
      ),
    );
  }
}