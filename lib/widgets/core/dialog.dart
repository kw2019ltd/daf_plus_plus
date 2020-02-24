import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  DialogWidget({
    @required this.child,
    this.onTapBackground,
    this.alignment = Alignment.center,
    this.margin = const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  });

  final Widget child;
  final Alignment alignment;
  final Function onTapBackground;
  final EdgeInsets margin;
  final BorderRadius borderRadius;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xBB000000),
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