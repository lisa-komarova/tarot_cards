import 'package:flutter/material.dart';
import 'package:taro_cards/widgets/card_list_page.dart';
import 'package:taro_cards/widgets/custom_app_bar.dart';

import '../datebase/cards_database.dart';
import '../models/taro_card.dart';

///main page with app bar, list of cards, bottom navigation bar
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _CardsListState createState() => _CardsListState();
}

class _CardsListState extends State<MainPage> {
  ///list of taro vards
  late List<TaroCard> taroCards;

  ///list of taro vards for search implementation
  late List<TaroCard> duplicateTaroCards = [];
  bool isLoading = false;

  ///controller for emptying search when navigationg to another list of cards
  TextEditingController editingController = TextEditingController();

  ///index for navigation between different lists of cards (major arcana, wand etc)
  int pageIndex = 0;

  @override
  void initState() {
    refreshTaroCards("Старшие арканы");
    super.initState();
  }

  ///builds app bar, list of cards and bottom navigation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomAppBar(
            searchHandler: _searchCards, controller: editingController),
      ),
      body: Container(
        alignment: Alignment.center,
        child: isLoading
            ? const CircularProgressIndicator()
            : taroCards.isEmpty
                ? Text(
                    "Таких карт нет!",
                    style: Theme.of(context).textTheme.headline6,
                  )
                : TaroCardsList(
                    taroCards: taroCards,
                  ),
      ),
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  ///filtering cards
  void _searchCards(String searchText) {
    List<TaroCard> dummySearchList = [];
    dummySearchList.addAll(duplicateTaroCards);
    if (searchText.isNotEmpty) {
      List<TaroCard> dummyListData = [];
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
    setState(() => isLoading = true);
    duplicateTaroCards.clear();
    switch (category) {
      case "Старшие арканы":
        taroCards = await TaroCardsDatabase.instance.readAllMajorArcana();
        break;
      case "Жезлы":
        taroCards = await TaroCardsDatabase.instance.readAllWands();
        break;
      case "Кубки":
        taroCards = await TaroCardsDatabase.instance.readAllCups();
        break;
      case "Мечи":
        taroCards = await TaroCardsDatabase.instance.readAllSwords();
        break;
      case "Пентакли":
        taroCards = await TaroCardsDatabase.instance.readAllPentacles();
        break;
      default:
    }
    duplicateTaroCards.addAll(taroCards);
    setState(() => isLoading = false);
  }

  ///bottom navigation
  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomAppBarColor,
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
                refreshTaroCards("Старшие арканы");
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
                refreshTaroCards("Жезлы");
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
                refreshTaroCards("Кубки");
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
                refreshTaroCards("Мечи");
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
                refreshTaroCards("Пентакли");
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
}
