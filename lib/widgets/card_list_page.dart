import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:taro_cards/ads/ad_helper.dart';
import 'package:taro_cards/models/taro_card.dart';
import '../pages/card_page.dart';

///builds grid view with tarot cards
class TaroCardsList extends StatefulWidget {
  final List<TaroCard> taroCards;
  const TaroCardsList({Key? key, required this.taroCards}) : super(key: key);
  @override
  _CardPageListState createState() => _CardPageListState();
}

class _CardPageListState extends State<TaroCardsList> {
  InterstitialAd? _interstitialAd;
  int numberOfCardsOpened = 0;
  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildTaroCards(),
    );
  }

  Widget buildTaroCards() => GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1 / 1.72,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: widget.taroCards.length,
      itemBuilder: (BuildContext ctx, index) {
        return GestureDetector(
          onTap: (() {
            numberOfCardsOpened++;
            if (numberOfCardsOpened > 1) {
              numberOfCardsOpened = 0;
              _loadInterstitialAd();
              if (_interstitialAd != null) {
                _interstitialAd?.show();
              }
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CardPage(cardId: widget.taroCards[index].cardId),
              ),
            );
          }),
          child: Container(
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
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xFF5E017D),
                          borderRadius: BorderRadius.circular(15)),
                      child: FittedBox(
                        child: Image.network(widget.taroCards[index].imagePath),
                        fit: BoxFit.fitHeight,
                      )),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.taroCards[index].cardName,
                            style: Theme.of(context).textTheme.headline6)))
              ],
            ),
          ),
        );
      });

  ///loading ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {},
      ),
    );
  }
}
