import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taro_cards/bloc/tarot_card_bloc.dart';
import 'package:taro_cards/bloc/tarot_card_event.dart';

import 'locale_event.dart';

/// Bloc responsible for managing the app's locale (language) changes.
///
/// This bloc handles `LocaleEvent`s and updates the app's current `Locale`.
/// It also persists the selected locale in [SharedPreferences] and notifies
/// the [TarotCardBloc] to refresh tarot card data according to the new locale.
class LocaleBloc extends Bloc<LocaleEvent, Locale> {
  /// Reference to the [TarotCardBloc] for updating card data on locale change.
  final TarotCardBloc tarotCardBloc;

  /// The system's default locale used as initial state.
  final Locale systemLocale;

  /// Creates a [LocaleBloc] with required [tarotCardBloc] and [systemLocale].
  LocaleBloc({required this.tarotCardBloc, required this.systemLocale})
      : super(systemLocale) {
    // Register event handler for ChangeLocale events.
    on<ChangeLocale>(_onChangeLocale);
  }

  /// Handles [ChangeLocale] events.
  ///
  /// Updates the [TarotCardBloc] with the new locale and category,
  /// persists the locale in [SharedPreferences], and emits the new locale.
  Future<void> _onChangeLocale(ChangeLocale event, Emitter<Locale> emit) async {
    final localeCode = event.locale.languageCode;

    // Notify TarotCardBloc to reload cards in the new locale.
    tarotCardBloc.add(TarotChangeLocale(
      locale: localeCode,
      category: event.category,
    ));

    // Persist the new locale to shared preferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', localeCode);

    // Emit the new locale state.
    emit(event.locale);
  }
}
