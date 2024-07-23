import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:taro_cards/database/cards_database.dart';
import 'package:taro_cards/models/card_combination.dart';
import 'package:taro_cards/models/taro_card.dart';

///builds drop-down list of cards and the meaning of
///combination with a chosen card from the drop-down-list
class CombinationWidget extends StatefulWidget {
  final TaroCard taroCard;
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
  late TaroCard _secondCard;
  List<TaroCard> _taroCards = [];
  late final Future<List<TaroCard>> _loadedTaroCards;
  late CardCombintaion _cardCombintaion;
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
    var cardCombintaion = (await TaroCardsDatabase.instance
        .readCombination(widget.taroCard, _secondCard))!;
    setState(() {
      _cardCombintaion = cardCombintaion;
    });
  }

  ///gets the list of cards for drop-down list
  ///sets the default second card
  ///and the combination with the second card
  Future<List<TaroCard>> _readTaroCards() async {
    final List<TaroCard> allTaroCards =
        await TaroCardsDatabase.instance.readAllTaroCards();
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
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: FutureBuilder(
          future: _loadedTaroCards,
          builder: ((context, snapshot) {
            if (snapshot.data != null) {
              _taroCards = snapshot.data as List<TaroCard>;
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
                      'Расcчитать комбинации',
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
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 18, right: 18, left: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownSearch(
                      popupProps: PopupProps.dialog(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        )),
                        emptyBuilder: (context, searchEntry) => const Center(
                          child: Text('Нет такой карты ˙◠˙'),
                        ),
                      ),
                      items: taroCardsNames,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        label: Text(
                          "Вторая карта",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )),
                      onChanged: _changeSecondCard,
                      selectedItem: _secondCard.cardName,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 18, right: 18, left: 18),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Text('Значение: ${_cardCombintaion.value}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 18)),
                    ),
            ),
          ],
        )
    ]);
  }
}
