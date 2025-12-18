import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Tarot card meanings'**
  String get title;

  /// No description provided for @theGeneralMeaning.
  ///
  /// In en, this message translates to:
  /// **'the general meaning'**
  String get theGeneralMeaning;

  /// No description provided for @uprigth.
  ///
  /// In en, this message translates to:
  /// **'uprigth:'**
  String get uprigth;

  /// No description provided for @reversed.
  ///
  /// In en, this message translates to:
  /// **'reversed:'**
  String get reversed;

  /// No description provided for @loveMeaning.
  ///
  /// In en, this message translates to:
  /// **'love meaning'**
  String get loveMeaning;

  /// No description provided for @situationOrQuestion.
  ///
  /// In en, this message translates to:
  /// **'situation or question'**
  String get situationOrQuestion;

  /// No description provided for @cardOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'card of the day'**
  String get cardOfTheDay;

  /// No description provided for @advice.
  ///
  /// In en, this message translates to:
  /// **'advice'**
  String get advice;

  /// No description provided for @yesOrNo.
  ///
  /// In en, this message translates to:
  /// **'yes or no'**
  String get yesOrNo;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'health'**
  String get health;

  /// No description provided for @combinationOfTwoCards.
  ///
  /// In en, this message translates to:
  /// **'combination of two cards'**
  String get combinationOfTwoCards;

  /// No description provided for @firstCard.
  ///
  /// In en, this message translates to:
  /// **'first card'**
  String get firstCard;

  /// No description provided for @secondCard.
  ///
  /// In en, this message translates to:
  /// **'second card'**
  String get secondCard;

  /// No description provided for @meaning.
  ///
  /// In en, this message translates to:
  /// **'meaning'**
  String get meaning;

  /// No description provided for @noSuchCards.
  ///
  /// In en, this message translates to:
  /// **'no such cards ˙◠˙'**
  String get noSuchCards;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'source'**
  String get source;

  /// No description provided for @cardName.
  ///
  /// In en, this message translates to:
  /// **'CARD NAME:'**
  String get cardName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY:'**
  String get category;

  /// No description provided for @majorArcana.
  ///
  /// In en, this message translates to:
  /// **'Major Arcana'**
  String get majorArcana;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'NUMBER:'**
  String get number;

  /// No description provided for @uprigthCapital.
  ///
  /// In en, this message translates to:
  /// **'UPRIGTH:'**
  String get uprigthCapital;

  /// No description provided for @reversedCapital.
  ///
  /// In en, this message translates to:
  /// **'REVERSED:'**
  String get reversedCapital;

  /// No description provided for @pleaseCheckInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check internet connection ˙◠˙'**
  String get pleaseCheckInternetConnection;

  /// No description provided for @wands.
  ///
  /// In en, this message translates to:
  /// **'Wands'**
  String get wands;

  /// No description provided for @cups.
  ///
  /// In en, this message translates to:
  /// **'Cups'**
  String get cups;

  /// No description provided for @swords.
  ///
  /// In en, this message translates to:
  /// **'Swords'**
  String get swords;

  /// No description provided for @pentacles.
  ///
  /// In en, this message translates to:
  /// **'Pentacles'**
  String get pentacles;

  /// No description provided for @cardsdb.
  ///
  /// In en, this message translates to:
  /// **'cards_en.db'**
  String get cardsdb;

  /// No description provided for @chooseLang.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLang;

  /// No description provided for @yearReading.
  ///
  /// In en, this message translates to:
  /// **'tarot reading for 2026'**
  String get yearReading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
