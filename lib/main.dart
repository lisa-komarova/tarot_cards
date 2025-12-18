import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taro_cards/database/cards_database.dart';
import 'package:taro_cards/pages/language_page.dart';
import 'package:taro_cards/pages/main_page.dart';
import 'package:taro_cards/repositories/tarot_card_repository.dart';
import 'package:taro_cards/s.dart';
import 'package:taro_cards/theme/theme.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import 'bloc/locale_bloc.dart';
import 'bloc/locale_event.dart';
import 'bloc/tarot_card_bloc.dart';

/// Application entry point.
///
/// Initializes Flutter bindings, local storage, database,
/// licenses, and core BLoCs before running the app.
///
/// Responsibilities:
/// - Restore saved locale from SharedPreferences
/// - Initializes the ad system
/// - Initialize the tarot cards database
/// - Register bundled licenses
/// - Create and provide BLoC instances

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.initialize();
  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = await prefs.getString('locale');
  await TarotCardsDatabase().init();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  final tarotBloc = TarotCardBloc(TarotCardRepository());
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final localeBloc =
      LocaleBloc(tarotCardBloc: tarotBloc, systemLocale: systemLocale);

  if (savedLocaleCode != null) {
    localeBloc.add(
      ChangeLocale(
        locale: Locale(savedLocaleCode),
        category: savedLocaleCode == 'ru' ? 'Старшие арканы' : 'Major Arcana',
      ),
    );
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => tarotBloc),
        BlocProvider(create: (_) => localeBloc),
      ],
      child: MyApp(
        savedLocaleCode: savedLocaleCode,
      ),
    ),
  );
}

/// Root widget of the application.
class MyApp extends StatefulWidget {
  /// Holds the previously saved locale code (if any).
  ///
  /// Used to decide whether to show the language
  /// selection screen or navigate directly to the main page
  final String? savedLocaleCode;

  const MyApp({super.key, required this.savedLocaleCode});

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
        home: widget.savedLocaleCode != null ? MainPage() : LanguagePage(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

