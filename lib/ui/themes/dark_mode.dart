import 'package:flutter/material.dart';

final ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.blue[200]!,
    primaryContainer: Colors.blue[300]!,
    onTertiaryContainer: Colors.grey.shade800,
    secondary: Colors.green[200]!,
    secondaryContainer: const Color.fromRGBO(27, 66, 66, 1),
    surface: Colors.black,
    error: Colors.red[400]!,
    onPrimary: const Color.fromRGBO(27, 29, 40, 0.8),
    onSecondary: Colors.black,

    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  ),
);