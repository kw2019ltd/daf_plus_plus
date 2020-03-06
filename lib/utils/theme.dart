import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeUtil {
  getTheme(BuildContext context) {
    return ThemeData(
      // colors
      brightness: Brightness.light,
      primaryColor: Colors.indigo[500],
      accentColor: Colors.teal[200],
      backgroundColor: Colors.teal[50],

      // typography
      textTheme: GoogleFonts.alefTextTheme(
        Theme.of(context).textTheme,
      ).merge(
        TextTheme(
          bodyText2: TextStyle(
            fontSize: 18,
          ),
          headline5: TextStyle(
            color: Colors.white,
          ),
          headline6: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}

ThemeUtil themeUtil = new ThemeUtil();
