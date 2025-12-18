import 'package:flutter/material.dart';

/// Base class for locale-related events.
abstract class LocaleEvent {}

/// Event to change the app's locale (language) and optionally update category.
class ChangeLocale extends LocaleEvent {
  /// The new locale to apply.
  final Locale locale;

  /// The current category of tarot cards (used to refresh the list after locale change).
  final String category;

  /// Creates a [ChangeLocale] event.
  ChangeLocale({required this.locale, required this.category});
}
