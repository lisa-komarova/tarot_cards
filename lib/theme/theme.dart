import 'package:flutter/material.dart';

///theme for application
final lightTheme = ThemeData(
    fontFamily: 'Open Sans',
    primarySwatch: Colors.purple,
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      headlineLarge:
          TextStyle(fontSize: 100, color: Color.fromRGBO(70, 11, 90, 1)),
      headline6: TextStyle(fontSize: 20.0, color: Colors.black),
      headline5: TextStyle(fontSize: 6.0, color: Colors.purple),
    ),
    backgroundColor: Colors.purple.shade100,
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.transparent));

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  padding: const EdgeInsets.all(0),
);

class MainTitleStyle {
  static TextStyle mainTitle(BuildContext context) {
    return Theme.of(context).textTheme.headline1!.copyWith(
        fontSize: 100,
        fontWeight: FontWeight.w700,
        color: const Color.fromRGBO(70, 11, 90, 1));
  }
}
