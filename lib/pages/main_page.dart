import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:taro_cards/bloc/tarot_card_bloc.dart';
import 'package:taro_cards/bloc/tarot_card_state.dart';
import 'package:taro_cards/widgets/tarot_card_list.dart';
import 'package:taro_cards/widgets/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/locale_bloc.dart';
import '../bloc/locale_event.dart';
import '../bloc/tarot_card_event.dart';
import '../models/tarot_card.dart';

///main page with app bar, list of cards, bottom navigation bar
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State createState() => _CardsListState();
}

class _CardsListState extends State<MainPage> {
  ///list of tarot cards
  late List<TarotCard> taroCards;

  ///list of tarot cards for search implementation
  late List<TarotCard> duplicateTaroCards = [];
  bool isInternetConnected = true;

  ///controller for emptying search when navigationg to another list of cards
  TextEditingController editingController = TextEditingController();

  ///index for navigation between different lists of cards (major arcana, wand etc)
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

  ///builds app bar, list of cards and bottom navigation
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
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkResponse(
                    child: Text(
                      currentLocale.languageCode.toUpperCase(),
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
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
                          category = newLocale.languageCode == 'en'
                              ? 'Wands'
                              : 'Жезлы';
                          break;
                        case 2:
                          category =
                              newLocale.languageCode == 'en' ? 'Cups' : 'Кубки';
                          break;
                        case 3:
                          category = newLocale.languageCode == 'en'
                              ? 'Swords'
                              : 'Мечи';
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

  ///filtering cards
  void _searchCards(String searchText) {
    List<TarotCard> dummySearchList = [];
    dummySearchList.addAll(duplicateTaroCards);
    if (searchText.isNotEmpty) {
      List<TarotCard> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.cardName.toLowerCase().contains(searchText)) {
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

  ///changes the list of cards
  Future refreshTaroCards(category) async {
    duplicateTaroCards.clear();
    context.read<TarotCardBloc>().add(LoadCardsByCategory(
        category, context.read<LocaleBloc>().state.languageCode));
  }

  ///bottom navigation
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
            icon: pageIndex == 0
                ? Image.asset('assets/icons/main_arcana_purple.png')
                : Image.asset('assets/icons/main_arcana_grey.png'),
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
            icon: pageIndex == 1
                ? Image.asset('assets/icons/wands_purple.png')
                : Image.asset('assets/icons/wands_grey.png'),
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
            icon: pageIndex == 2
                ? Image.asset('assets/icons/cups_purple.png')
                : Image.asset('assets/icons/cups_grey.png'),
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
            icon: pageIndex == 3
                ? Image.asset('assets/icons/swords_purple.png')
                : Image.asset('assets/icons/swords_grey.png'),
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
            icon: pageIndex == 4
                ? Image.asset('assets/icons/pentacles_purple.png')
                : Image.asset('assets/icons/pentacles_grey.png'),
          ),
        ],
      ),
    );
  }

  void checkInternet() async {
    isInternetConnected = await InternetConnection().hasInternetAccess;
  }
}
