import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:taro_cards/ads/ad_helper.dart';
import 'package:taro_cards/models/card_value.dart';
import 'package:taro_cards/models/taro_card.dart';
import 'package:taro_cards/widgets/combination_widget.dart';

import '../database/cards_database.dart';
import '../widgets/card_value_button.dart';
import 'package:url_launcher/url_launcher.dart';

///cardpage widget is for displaying taro card and its values
class CardPage extends StatefulWidget {
  ///taro card id
  final int cardId;

  const CardPage({Key? key, required this.cardId}) : super(key: key);
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late TaroCard taroCard;
  late String cardDetails;
  late CardValue cardValue;
  bool isLoading = true;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    getTaroCard();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD TARO');
    return Container(
      color: Theme.of(context).backgroundColor,
      width: double.infinity,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildTaroCard(),
    );
  }

  ///reads taro card from db
  Future getTaroCard() async {
    taroCard = (await TaroCardsDatabase.instance.readTaroCard(widget.cardId))!;
    cardDetails = "НАЗВАНИЕ АРКАНА: " +
        taroCard.cardName +
        " \n"
            " КАТЕГОРИЯ: " +
        taroCard.category +
        " \n"
            " ПРЯМОЕ ПОЛОЖЕНИЕ: " +
        taroCard.upward +
        "\n"
            " ПЕРЕВЕРНУТОЕ ПОЛОЖЕНИЕ:  " +
        taroCard.downward;
  }

  ///builds taro card, its values and combination of the card with other cards
  Widget buildTaroCard() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 40,
          ),
          if (_bannerAd != null)
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropCapText(cardDetails,
                style: Theme.of(context).textTheme.headline6,
                dropCap: DropCap(
                    width: 170, height: 212, child: buildTaroCardImage())),
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
              CombinationWidget(
                taroCard: taroCard,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = (() => {
                            launchUrl(Uri.parse(
                                'https://astrohelper.ru/gadaniya/taro/znachenie/'))
                          }),
                    text: "Источник",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontStyle: FontStyle.italic)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///builds a container with the image of a taro card
  Widget buildTaroCardImage() {
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
