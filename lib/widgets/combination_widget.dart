import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:taro_cards/database/cards_database.dart';
import 'package:taro_cards/models/card_combination.dart';
import 'package:taro_cards/models/taro_card.dart';

///builds drop-down list of cards and the meaning of
///combination with a chosen card from the drop-down-list
class CombinationWidget extends StatefulWidget {
  final TaroCard taroCard;
  const CombinationWidget({Key? key, required this.taroCard}) : super(key: key);

  @override
  State<CombinationWidget> createState() => _CombinationWidgetState();
}

class _CombinationWidgetState extends State<CombinationWidget> {
  bool visibility = false;
  bool isLoading = true;
  late TaroCard _secondCard;
  List<TaroCard> _taroCards = [];
  late final Future<List<TaroCard>> _loadedTaroCards;
  late CardCombintaion _cardCombintaion;

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
  _changeSecondCard(String? taroCardName) {
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
      color: Theme.of(context).backgroundColor,
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
          onTap: () => setState(() => visibility = !visibility),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Расчитать комбинации',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                    child: visibility == true
                        ? const Icon(
                            Icons.arrow_drop_up,
                            color: Color(0xFF5E017D),
                            size: 60,
                          )
                        : const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFF5E017D),
                            size: 60,
                          )),
              ],
            ),
          ),
        ),
      ),
      if (visibility)
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownSearch(
                      mode: Mode.DIALOG,
                      items: taroCardsNames,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Вторая карта",
                      ),
                      onChanged: _changeSecondCard,
                      selectedItem: _secondCard.cardName,
                      showSearchBox: true,
                      emptyBuilder: (context, searchEntry) => const Center(
                        child: Text('Нет такой карты ˙◠˙'),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Значение: ${_cardCombintaion.value}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
            ),
          ],
        )
    ]);
  }
}
