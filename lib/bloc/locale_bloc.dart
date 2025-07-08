import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taro_cards/bloc/tarot_card_bloc.dart';
import 'package:taro_cards/bloc/tarot_card_event.dart';

import 'locale_event.dart';

///bloc for changing locale
class LocaleBloc extends Bloc<LocaleEvent, Locale> {
  final TarotCardBloc tarotCardBloc;

  LocaleBloc({required this.tarotCardBloc}) : super(const Locale('en')) {
    on<ChangeLocale>(_onChangeLocale);
  }

  Future<void> _onChangeLocale(ChangeLocale event, Emitter<Locale> emit) async {
    final localeCode = event.locale.languageCode;

    tarotCardBloc.add(TarotChangeLocale(
      locale: localeCode,
      category: event.category,
    ));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', localeCode);
    emit(event.locale);
  }
}
