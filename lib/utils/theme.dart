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

      // typography
      textTheme: GoogleFonts.frankRuhlLibreTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }
}

ThemeUtil themeUtil = new ThemeUtil();
