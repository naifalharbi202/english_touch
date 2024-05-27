import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

ThemeData lightMode = ThemeData(
    primaryColor: defaultColor,
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        color: Colors.white,
        elevation: 0.0),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: defaultColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
        bodyLarge: TextStyle(
      fontFamily: 'Cairo',
      color: Colors.black,
    )));

ThemeData darkMode = ThemeData(
  appBarTheme: const AppBarTheme(
      color: Colors.black,
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light, //Controls status bar
          statusBarColor: Colors.black)),
  scaffoldBackgroundColor: const Color.fromARGB(255, 11, 11, 11),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0.7,
      backgroundColor: Color.fromARGB(255, 24, 23, 23),
      selectedItemColor: Color.fromARGB(255, 14, 76, 87),
      unselectedItemColor: Colors.white),
  inputDecorationTheme:
      const InputDecorationTheme(labelStyle: TextStyle(color: Colors.grey)),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
);
