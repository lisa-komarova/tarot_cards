import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taro_cards/database/cards_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taro_cards/models/card_combination.dart';
import 'package:taro_cards/models/tarot_card.dart';

import '../bloc/locale_bloc.dart';

///builds two cards and their combination meaning
///the second card is chosen in a dialog
class CombinationWidget extends StatefulWidget {
  final TarotCard taroCard;

  const CombinationWidget({super.key, required this.taroCard});

  @override
  State<CombinationWidget> createState() => _CombinationWidgetState();
}

class _CombinationWidgetState extends State<CombinationWidget>
    with SingleTickerProviderStateMixin {
  static const _color = Colors.white;

  late final _controller = AnimationController(vsync: this);
  bool visibility = false;
  bool isLoading = true;
  late TarotCard _secondCard;
  List<TarotCard> _taroCards = [];
  late final Future<List<TarotCard>> _loadedTaroCards;
  late CardCombination _cardCombintaion;
  final TextEditingController _searchController = TextEditingController();

  void _toggleCard() {
    setState(() => visibility = !visibility);
    switch (_controller.status) {
      case AnimationStatus.dismissed:
        _controller.forward();
        break;
      case AnimationStatus.forward:
        _controller.reverse();
        break;
      case AnimationStatus.reverse:
        _controller.forward();
        break;
      case AnimationStatus.completed:
        _controller.reverse();
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = const Duration(milliseconds: 500);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadedTaroCards = _readTaroCards();
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  ///gets the meaning of the combination of two cards
  void _readCardCombination() async {
    var cardCombintaion = (await TarotCardsDatabase.instance.readCombination(
        widget.taroCard,
        _secondCard,
        context.read<LocaleBloc>().state.languageCode))!;
    setState(() {
      _cardCombintaion = cardCombintaion;
    });
  }

  ///gets the list of cards for drop-down list
  ///sets the default second card
  ///and the combination with the second card
  Future<List<TarotCard>> _readTaroCards() async {
    final locale = context.read<LocaleBloc>().state;
    final List<TarotCard> allTaroCards =
        await TarotCardsDatabase.instance.readAllTaroCards(locale.languageCode);
    allTaroCards.removeWhere((item) => item.cardId == widget.taroCard.cardId);
    _secondCard = allTaroCards.first;
    _readCardCombination();
    return allTaroCards;
  }

  ///sets the second card and gets its combination
  void _changeSecondCard(dynamic taroCardName) {
    if (taroCardName != null) {
      setState(() {
        _secondCard = _taroCards
            .where((item) => item.cardName == taroCardName)
            .toList()
            .first;
      });
      _readCardCombination();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: FutureBuilder(
          future: _loadedTaroCards,
          builder: ((context, snapshot) {
            if (snapshot.data != null) {
              _taroCards = snapshot.data as List<TarotCard>;
              List<String> taroCardsNames = [];
              for (var card in _taroCards) {
                taroCardsNames.add(card.cardName);
              }
              return buildCombination(taroCardsNames);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          })),
    );
  }

  Widget buildCombination(List<String> taroCardsNames) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: _toggleCard,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 60,
              decoration: DecorationTween(
                begin: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: _color,
                ),
                end: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: _color.withOpacity(0.4),
                ),
              ).evaluate(_controller),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).combinationOfTwoCards,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Transform.rotate(
                      angle: Tween(begin: 0.0, end: pi).evaluate(_controller),
                      child: const Icon(
                        Icons.arrow_drop_up,
                        color: Color(0xFF5E017D),
                        size: 60,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      if (visibility)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        AppLocalizations.of(context).firstCard,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(
                          widget.taroCard.cardName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/icons/add.png',
                  width: 25,
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    _buildCardCombinationDialog(
                        context, taroCardsNames, _secondCard);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(AppLocalizations.of(context).secondCard),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(
                          child: Text(
                            _secondCard.cardName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/icons/equals.png',
                  width: 25,
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(AppLocalizations.of(context).meaning),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 50.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              _cardCombintaion.value,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    ]);
  }

  Future<void> _buildCardCombinationDialog(
      BuildContext context, List<String> taroCardsNames, TarotCard secondCard) {
    List<String> duplicateTaroCardsNames = [];
    duplicateTaroCardsNames.addAll(taroCardsNames);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 500,
            width: 250,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: TextField(
                    onChanged: (searchText) {
                      List<String> dummySearchList = [];
                      dummySearchList.addAll(duplicateTaroCardsNames);
                      if (searchText.isNotEmpty) {
                        List<String> dummyListData = [];
                        for (var item in dummySearchList) {
                          if (item.toLowerCase().contains(searchText)) {
                            dummyListData.add(item);
                          }
                        }
                        setState(() {
                          taroCardsNames.clear();
                          taroCardsNames.addAll(dummyListData);
                        });
                        return;
                      } else {
                        setState(() {
                          taroCardsNames.clear();
                          taroCardsNames.addAll(duplicateTaroCardsNames);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Colors.black38,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(35)),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 450,
                      child: taroCardsNames.isEmpty
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context).noSuchCards,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: taroCardsNames.length,
                              itemBuilder: (ctx, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _changeSecondCard(taroCardsNames[index]);
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            height: 30,
                                            child: Text(
                                              taroCardsNames[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            )),
                                      ),
                                      Image.asset(
                                        'assets/icons/divider.png',
                                        width: 10,
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                    ),
                  ),
                )
              ],
            ),
          );
        }));
      },
    );
  }
}
