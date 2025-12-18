import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:taro_cards/bloc/tarot_card_bloc.dart';
import 'package:taro_cards/bloc/tarot_card_state.dart';
import 'package:taro_cards/widgets/tarot_card_list.dart';
import 'package:taro_cards/widgets/custom_app_bar.dart';
import '../bloc/locale_bloc.dart';
import '../bloc/locale_event.dart';
import '../bloc/tarot_card_event.dart';
import '../l10n/app_localizations.dart';
import '../models/tarot_card.dart';

/// Main application page.
///
/// Displays:
/// - a searchable app bar,
/// - a grid of tarot cards,
/// - a bottom navigation bar for card categories.
///
/// Handles:
/// - internet connectivity state,
/// - language switching,
/// - category navigation,
/// - card search filtering.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State createState() => _CardsListState();
}

class _CardsListState extends State<MainPage> {
  /// Current list of tarot cards displayed on the screen.
  late List<TarotCard> taroCards;

  /// Backup list of tarot cards used for search filtering.
  ///
  /// Allows restoring the full list when the search query is cleared.
  late List<TarotCard> duplicateTaroCards = [];

  /// Indicates whether the device has an active internet connection.
  bool isInternetConnected = true;

  /// Controller used to clear the search field
  /// when switching between card categories.
  final TextEditingController editingController = TextEditingController();

  /// Index of the currently selected card category.
  ///
  /// Used for bottom navigation state and localization updates.
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    checkInternet();
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          setState(() {
            isInternetConnected = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isInternetConnected = false;
          });
          break;
      }
    });
  }

  /// Builds the main page layout including:
  /// - custom app bar with search,
  /// - tarot cards grid,
  /// - bottom navigation bar.
  @override
  Widget build(BuildContext context) {
    final currentLocale =
        context.select<LocaleBloc, Locale>((bloc) => bloc.state);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Row(
            children: [
              Expanded(
                child: CustomAppBar(
                    searchHandler: _searchCards, controller: editingController),
              ),
              InkResponse(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () async {
                  final newLocale = currentLocale.languageCode == 'en'
                      ? Locale('ru')
                      : Locale('en');
                  duplicateTaroCards.clear();
                  //await TarotCardsDatabase().init(newLocale.languageCode);
                  //appState.setLocale(newLocale);
                  final category;

                  switch (pageIndex) {
                    case 0:
                      category = newLocale.languageCode == 'en'
                          ? 'Major Arcana'
                          : 'Старшие арканы';
                      break;
                    case 1:
                      category =
                          newLocale.languageCode == 'en' ? 'Wands' : 'Жезлы';
                      break;
                    case 2:
                      category =
                          newLocale.languageCode == 'en' ? 'Cups' : 'Кубки';
                      break;
                    case 3:
                      category =
                          newLocale.languageCode == 'en' ? 'Swords' : 'Мечи';
                      break;
                    case 4:
                      category = newLocale.languageCode == 'en'
                          ? 'Pentacles'
                          : 'Пентакли';
                      break;
                    default:
                      category = newLocale.languageCode == 'en'
                          ? 'Major Arcana'
                          : 'Старшие арканы';
                  }
                  context.read<LocaleBloc>().add(
                        ChangeLocale(locale: newLocale, category: category),
                      );
                  //refreshTaroCards(category);
                },
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: Center(
                    child: Text(
                      currentLocale.languageCode.toUpperCase(),
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: BlocBuilder<TarotCardBloc, TarotCardState>(
          builder: (context, state) {
            if (state is TarotCardLoading) {
              return Center(child: const CircularProgressIndicator());
            } else if (state is TarotCardsLoaded) {
              taroCards = state.cards;
              if (duplicateTaroCards.isEmpty) {
                duplicateTaroCards.clear();
                duplicateTaroCards.addAll(taroCards);
              }
              return Container(
                alignment: Alignment.center,
                child: taroCards.isEmpty
                    ? Text(
                        AppLocalizations.of(context).noSuchCards,
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : isInternetConnected
                        ? TaroCardsList(
                            taroCards: taroCards,
                            editingController: editingController,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .pleaseCheckInternetConnection,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
              );
            } else if (state is TarotCardError) {
              return Text('Ошибка: ${state.message}');
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        bottomNavigationBar: buildMyNavBar(context),
      ),
    );
  }

  /// Filters tarot cards based on search input.
  ///
  /// Performs case-insensitive matching against card names.
  void _searchCards(String searchText) {
    List<TarotCard> dummySearchList = [];
    dummySearchList.addAll(duplicateTaroCards);
    if (searchText.isNotEmpty) {
      List<TarotCard> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.cardName
            .toLowerCase()
            .contains(searchText.trim().toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        taroCards.clear();
        taroCards.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        taroCards.clear();
        taroCards.addAll(duplicateTaroCards);
      });
    }
  }

  /// Requests tarot cards for the selected category.
  ///
  /// Clears cached search data and triggers
  /// a new [LoadCardsByCategory] event.
  Future refreshTaroCards(category) async {
    duplicateTaroCards.clear();
    context.read<TarotCardBloc>().add(LoadCardsByCategory(
        category, context.read<LocaleBloc>().state.languageCode));
  }

  /// Builds the bottom navigation bar
  /// for switching between tarot card categories.
  ///
  /// Categories include:
  /// - Major Arcana
  /// - Wands
  /// - Cups
  /// - Swords
  /// - Pentacles
  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              editingController.clear();
              setState(() {
                refreshTaroCards(AppLocalizations.of(context).majorArcana);
                pageIndex = 0;
              });
            },
            splashRadius: 1,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Image.asset(
              'assets/icons/main_arcana_purple.png',
              color: pageIndex == 0
                  ? const Color(0xFF690083)
                  : const Color(0xFFCDCDCD),
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              editingController.clear();
              setState(() {
                refreshTaroCards(AppLocalizations.of(context).wands);
                pageIndex = 1;
              });
            },
            splashRadius: 1,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Image.asset(
              'assets/icons/wands_purple.png',
              color: pageIndex == 1
                  ? const Color(0xFF690083)
                  : const Color(0xFFCDCDCD),
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              editingController.clear();
              setState(() {
                refreshTaroCards(AppLocalizations.of(context).cups);
                pageIndex = 2;
              });
            },
            splashRadius: 1,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Image.asset(
              'assets/icons/cups_purple.png',
              color: pageIndex == 2
                  ? const Color(0xFF690083)
                  : const Color(0xFFCDCDCD),
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              editingController.clear();
              setState(() {
                refreshTaroCards(AppLocalizations.of(context).swords);
                pageIndex = 3;
              });
            },
            splashRadius: 1,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Image.asset(
              'assets/icons/swords_purple.png',
              color: pageIndex == 3
                  ? const Color(0xFF690083)
                  : const Color(0xFFCDCDCD),
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              editingController.clear();
              setState(() {
                refreshTaroCards(AppLocalizations.of(context).pentacles);
                pageIndex = 4;
              });
            },
            splashRadius: 1,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Image.asset(
              'assets/icons/pentacles_purple.png',
              color: pageIndex == 4
                  ? const Color(0xFF690083)
                  : const Color(0xFFCDCDCD),
            ),
          ),
        ],
      ),
    );
  }

  void checkInternet() async {
    isInternetConnected = await InternetConnection().hasInternetAccess;
  }
}
