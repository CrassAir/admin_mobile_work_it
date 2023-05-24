import 'package:flutter/material.dart';

class Styles {
  static ThemeData darkMode(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
      ),
      // indicatorColor: const Color(0xff0E1D36),
      cardTheme: const CardTheme(color: Color(0xff3A3A3B)),
      // appBarTheme: const AppBarTheme(backgroundColor: Color(0xff3A3A3B)),
      hintColor: Colors.white70.withOpacity(1),
      canvasColor: Colors.black,
      // highlightColor: const Color(0xff372901),
      // hoverColor: const Color(0xff3A3A3B),
      focusColor: const Color(0xff0B2512),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
      disabledColor: Colors.grey,
      // cardTheme: const CardTheme(color: Color(0xff3A3A3B)),
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff3A3A3B)))),
      // appBarTheme: AppBarTheme(
      //   elevation: 0.0,
      // ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 4),
        displayMedium: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 4),
      ),
      textSelectionTheme: const TextSelectionThemeData(selectionColor: Colors.white),
    );
  }

  static ThemeData lightMode(BuildContext context) {
    Color white = const Color(0xffe8e8e8);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        backgroundColor: white,
      ),
      canvasColor: white,
      appBarTheme: AppBarTheme(backgroundColor: white),
      cardTheme: const CardTheme(color: Colors.white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }
}
