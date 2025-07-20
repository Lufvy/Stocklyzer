import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Apptheme {
  static const LinearGradient lightGradient = LinearGradient(
    colors: [Colors.white, Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0XFF01353D), Color(0XFF007283)],
    stops: [0.1, 0.75],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      primaryColor: Colors.white,

      colorScheme: ColorScheme.dark(
        primary: Color(0XFF007283),
        secondary: Colors.black,
        background: Color(0XFF007283),
        onPrimary: Colors.white,
        onSecondary: Color(0XFF01353D),

        // onPrimaryContainer: ,
        // onSecondaryContainer: ,
        // primaryContainer: ,
        // secondaryContainer: ,
        // outline: ,
        // surface: Color(0XFF000000).withOpacity(0.4),
      ),

      // primaryColorLight: ,
      // primaryColorDark: ,
      // primaryIconTheme: ,
      iconTheme: IconThemeData(color: Colors.white.withOpacity(0.75)),
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
      // primaryTextTheme: GoogleFonts.poppinsTextTheme().apply(
      //   bodyColor: Colors.white,
      // ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Colors.white,
        selectionHandleColor: Colors.white,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Color(0XFF007283),

      colorScheme: const ColorScheme.light(
        primary: Colors.white,
        secondary: Color(0XFF01ABC4),
        onPrimary: Colors.black,
        background: Color(0XFFBBBBBB),
        onSecondary: Color(0XFF01353D),
      ),
      iconTheme: IconThemeData(color: Colors.black.withOpacity(0.50)),

      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.black),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0XFF007283),
        selectionColor: Color(0XFF007283),
        selectionHandleColor: Color(0XFF007283),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
