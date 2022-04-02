import 'package:flutter/material.dart';

enum AppTheme {
  LightAppTheme,
  DarkAppTheme,
}

final appThemeData = {
  AppTheme.DarkAppTheme: ThemeData(
    scaffoldBackgroundColor: Colors.white24,
    primaryColor: Colors.redAccent,
    appBarTheme: AppBarTheme(color: Colors.white24),

    textTheme: TextTheme(
      headline3: TextStyle().copyWith(color: Colors.white,fontSize: 14),

    ),
  ),
  AppTheme.LightAppTheme: ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.greenAccent,
    appBarTheme: AppBarTheme(color: Colors.lightBlueAccent),
    textTheme: TextTheme(
      headline3: TextStyle().copyWith(color: Colors.black,fontSize: 14),
    ),
  ),
};
