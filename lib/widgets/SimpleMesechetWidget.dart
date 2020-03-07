import 'package:flutter/material.dart';

class SimpleMesechetWidget extends StatelessWidget {
  SimpleMesechetWidget({
    @required this.name,
    @required this.onChange,
    @required this.checked
  });

  final String name;
  final bool checked;
  final Function(bool) onChange;

  void _onClickCheckbox(bool state) {
    onChange(state);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntrinsicHeight(
          child: CheckboxListTile(
            title: Text(name),
            onChanged: _onClickCheckbox,
            value: checked,
            controlAffinity: ListTileControlAffinity.leading,
          )
      ),
    );
  }
}