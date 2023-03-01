import 'package:flutter/material.dart';

/// App's branded color.
const appColor = Color.fromRGBO(0, 179, 255, 1);

/// Dark app theme.
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: appColor,
);

/// Light app theme.
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: appColor,
);
