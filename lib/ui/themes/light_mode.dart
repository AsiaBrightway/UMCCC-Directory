import 'package:flutter/material.dart';

 final ThemeData lightMode = ThemeData(
   colorScheme: ColorScheme.light(
     primary: Colors.blue,
     primaryContainer: Colors.blue[700]!,
     onTertiaryContainer: Colors.grey.shade300,
     secondary: Colors.green,
     secondaryContainer: const Color.fromRGBO(242, 255, 249, 1),
     surface: Colors.grey.shade300,
     error: Colors.red,
     onPrimary: Colors.white,
     onSecondary: Colors.white,
     onSurface: Colors.black,
     onBackground: Colors.black,
     onError: Colors.white,
     brightness: Brightness.light,
   ),
 );