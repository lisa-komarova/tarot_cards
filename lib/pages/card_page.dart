import 'package:flutter/material.dart';
import 'package:taro_cards/models/card_value.dart';
import 'package:taro_cards/models/taro_card.dart';
import 'package:taro_cards/widgets/ad_widget.dart';
import 'package:taro_cards/widgets/combination_widget.dart';
import 'package:taro_cards/widgets/source_widget.dart';

import '../database/cards_database.dart';
import '../widgets/card_value_button.dart';

///cardpage widget is for displaying tarot card and its values
class CardPage extends StatefulWidget {
  ///tarot card id
  final int cardId;

  const CardPage({Key? key, required this.cardId}) : super(key: key);
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late TaroCard taroCard;
  late CardValue cardValue;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getTaroCard();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).backgroundColor,
        width: double.infinity,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : buildTaroCard(),
      ),
    );
  }

  ///reads tarot card from db
  Future getTaroCard() async {
    taroCard = (await TaroCardsDatabase.instance.readTaroCard(widget.cardId))!;
    setState(() {
            isLoading = false;
    });
  }

  ///builds tarot card, its values and combination of the card with other cards
  Widget buildTaroCard() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 10,
          ),
          const BannerAdvertisment(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  height: 345,
                  child: _buildTaroCardImage(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardCharacteristic(
                            "НАЗВАНИЕ АРКАНА: ", taroCard.cardName),
                        _buildCardCharacteristic(
                            "КАТЕГОРИЯ: ", taroCard.category),
                        _buildCardCharacteristic(
                            "ПРЯМОЕ ПОЛОЖЕНИЕ: ", taroCard.upward),
                        _buildCardCharacteristic(
                            "ПЕРЕВЕРНУТОЕ ПОЛОЖЕНИЕ: ", taroCard.downward),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              CardValueButton(
                title: "Общее значение",
                taroCard: taroCard,
              ),
              CardValueButton(
                title: "Значение в любви и отношениях",
                taroCard: taroCard,
              ),
              CardValueButton(
                title: "В ситуации и вопросе",
                taroCard: taroCard,
              ),
              CardValueButton(
                title: "Значение карты дня",
                taroCard: taroCard,
              ),
              CardValueButton(
                title: "Совет карты",
                taroCard: taroCard,
              ),
              CardValueButton(
                title: "Значение да/нет",
                taroCard: taroCard,
              ),
              CombinationWidget(
                taroCard: taroCard,
              ),
            ],
          ),
          const SourceWidget(
            url: 'https://astrohelper.ru/gadaniya/taro/znachenie/',
          ),
        ],
      ),
    );
  }

  ///builds basic characteristics of a tarot card
  Column _buildCardCharacteristic(String characteristic, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          characteristic,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  ///builds a container with the image of a tarot card
  Widget _buildTaroCardImage() {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Expanded(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFF5E017D),
                    borderRadius: BorderRadius.circular(15)),
                child: FittedBox(
                  child: Image.network(taroCard.imagePath),
                  fit: BoxFit.fitHeight,
                )),
          ),
          Container(
              padding: const EdgeInsets.only(left: 10, bottom: 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(taroCard.cardName,
                      style: Theme.of(context).textTheme.headline6))),
        ],
      ),
    );
  }
}
