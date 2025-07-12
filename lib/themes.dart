import 'package:flutter/material.dart';

final lightTheme = ThemeData(colorSchemeSeed: Color(0xFF0E1C36));

final darkTheme = ThemeData(
  colorSchemeSeed: Colors.green,
  scaffoldBackgroundColor: Color(0xffDEFFFC),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xffDEFFFC),
    shadowColor: Color(0xffDEFFFC),
    surfaceTintColor: Color(0xffDEFFFC),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: Color.fromARGB(255, 188, 226, 223),
  ),
);
