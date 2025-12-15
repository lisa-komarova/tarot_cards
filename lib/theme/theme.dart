import 'package:flutter/material.dart';

///theme for application
final lightTheme = ThemeData(
    fontFamily: 'Open Sans',
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      headlineLarge:
          TextStyle(fontSize: 100, color: Color.fromRGBO(70, 11, 90, 1)),
      titleLarge: TextStyle(fontSize: 20.0, color: Colors.black),
      headlineSmall: TextStyle(fontSize: 6.0, color: Colors.purple),
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(color: Colors.transparent),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
        .copyWith(background: Colors.purple.shade100));

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  padding: const EdgeInsets.all(0),
);

class MainTitleStyle {
  static TextStyle mainTitle(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
        fontSize: 100,
        fontWeight: FontWeight.w700,
        color: const Color.fromRGBO(70, 11, 90, 1));
  }
}
