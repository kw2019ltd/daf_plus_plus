import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  DialogWidget({
    @required this.child,
    this.onTapBackground,
    this.alignment = Alignment.center,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.hasShadow = true,
  });

  final Widget child;
  final Alignment alignment;
  final Function onTapBackground;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final bool hasShadow;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hasShadow ? Color(0xBB000000) : Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTapBackground != null ? onTapBackground : () {},
          child: Container(
            alignment: alignment,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: margin,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: borderRadius,
                  boxShadow: [
                    new BoxShadow(
                      color: Color(0x6a000000),
                      blurRadius: 20.0,
                    )
                  ],
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}