import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taro_cards/database/cards_database.dart';
import 'package:taro_cards/pages/main_page.dart';
import 'package:taro_cards/repositories/tarot_card_repository.dart';
import 'package:taro_cards/s.dart';
import 'package:taro_cards/theme/theme.dart';

import 'bloc/locale_bloc.dart';
import 'bloc/locale_event.dart';
import 'bloc/tarot_card_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localeCode = await prefs.getString('locale') ?? 'en';
  await TarotCardsDatabase().init();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  final tarotBloc = TarotCardBloc(TarotCardRepository());
  final localeBloc = LocaleBloc(tarotCardBloc: tarotBloc);

  localeBloc.add(ChangeLocale(
    locale: Locale(localeCode),
    category: localeCode == 'ru' ? 'Старшие арканы' : 'Major Arcana',
  ));

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => tarotBloc),
        BlocProvider(create: (_) => localeBloc),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, Locale>(builder: (context, locale) {
      return MaterialApp(
        supportedLocales: S.supportedLocales,
        locale: locale,
        localizationsDelegates: S.localizationDelegates,
        theme: lightTheme,
        home: MainPage(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
