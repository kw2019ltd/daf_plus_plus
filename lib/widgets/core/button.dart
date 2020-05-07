import 'package:flutter/material.dart';

enum ButtonType {
  Default,
  Filled,
  Outline,
}

class ButtonColors {
  ButtonColors({
    this.backgroundColor = const Color(0x00000000),
    this.outlineColor = const Color(0x00000000),
    this.textColor = const Color(0x00000000),
  });

  final Color backgroundColor;
  final Color outlineColor;
  final Color textColor;
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.subtext,
    this.onPressedDisabled,
    this.disabled = false,
    this.loading = false,
    this.buttonType = ButtonType.Default,
    this.color,
  });

  final String text;
  final Function onPressed;
  final String subtext;
  final Function onPressedDisabled;
  final bool disabled;
  final bool loading;
  final ButtonType buttonType;
  final Color color;

  ButtonColors _getButtonColors() {
    Map<ButtonType, ButtonColors> typeMap = {
      ButtonType.Default: ButtonColors(
        textColor: this.color,
      ),
      ButtonType.Outline: ButtonColors(
        outlineColor: this.color,
        textColor: this.color,
      ),
      ButtonType.Filled: ButtonColors(
        backgroundColor: this.color,
        outlineColor: this.color,
        textColor: Colors.white,
      ),
    };
    return typeMap[buttonType];
  }

  Widget _buttonContent(BuildContext context, ButtonColors buttonColors) {
    return Column(
      children: <Widget>[
        Text(
          text,
          style: Theme.of(context).textTheme.button.merge(
                TextStyle(color: buttonColors.textColor),
              ),
        ),
        if (subtext != null)
          Text(
            subtext,
            style: Theme.of(context).textTheme.caption.merge(
                  TextStyle(color: buttonColors.textColor),
                ),
          ),
      ],
    );
  }

  Widget _loadingButton(ButtonColors buttonColors) {
    return Container(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(buttonColors.textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ButtonColors buttonColors = _getButtonColors();
    return Container(
      foregroundDecoration: BoxDecoration(
        color: disabled ? Theme.of(context).accentColor : Colors.transparent,
        backgroundBlendMode: BlendMode.saturation,
      ),
      child: FlatButton(
        onPressed: !disabled ? onPressed : (onPressedDisabled ?? () => {}),
        color: buttonColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: buttonColors.outlineColor, width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: loading
              ? _loadingButton(buttonColors)
              : _buttonContent(context, buttonColors),
        ),
      ),
    );
  }
}
