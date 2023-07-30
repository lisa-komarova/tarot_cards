import 'package:flutter/material.dart';
import 'package:taro_cards/models/card_value.dart';
import 'package:taro_cards/models/taro_card.dart';
import 'package:taro_cards/widgets/card_value_widget.dart';

import '../datebase/cards_database.dart';

///widget for showing and hiding value of a card
class CardValueButton extends StatefulWidget {
  ///situation in wich card is read (meaning in love, card of a day etc)
  final String title;
  final TaroCard taroCard;
  const CardValueButton({Key? key, required this.title, required this.taroCard})
      : super(key: key);
  @override
  _CardValueButtonState createState() => _CardValueButtonState();
}

class _CardValueButtonState extends State<CardValueButton> {
  bool visibility = false;
  bool isLoading = true;
  List<CardValue?>? cardValues = [];
  @override
  void initState() {
    super.initState();
    getTaroCardValue();
  }

  ///reads values of a card (meaning in love, card of a day etc)
  Future getTaroCardValue() async {
    setState(() => isLoading = true);

    cardValues = (await TaroCardsDatabase.instance
        .readTaroCardValues(widget.taroCard.cardId));

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                    widget.title,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  )),
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
          SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CardValueWidget(
                      title: widget.title,
                      cardValues: cardValues,
                    ))),
          )
      ],
    );
  }
}
