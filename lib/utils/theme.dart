import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeUtil {
  getTheme(BuildContext context) {
    return ThemeData(
      // colors
      brightness: Brightness.light,
      primaryColor: Colors.indigo[500],
      accentColor: Colors.teal[300],
      backgroundColor: Colors.blueGrey[50],

      // typography
      textTheme: GoogleFonts.alefTextTheme(
        Theme.of(context).textTheme,
      ).merge(
        TextTheme(
          button: TextStyle(
            fontSize: 18,
          ),
          bodyText1: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          bodyText2: TextStyle(
            fontSize: 18,
          ),
          headline3: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
          headline5: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          headline6: TextStyle(
            fontSize: 24,
          ),
          caption: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

ThemeUtil themeUtil = new ThemeUtil();
