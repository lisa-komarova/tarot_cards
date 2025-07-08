import 'package:flutter/material.dart';

abstract class LocaleEvent {}

class ChangeLocale extends LocaleEvent {
  final Locale locale;
  final String category;

  ChangeLocale({required this.locale, required this.category});
}
