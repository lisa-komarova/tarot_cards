import 'package:flutter/material.dart';
import 'package:taro_cards/models/taro_card.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import '../pages/card_page.dart';

///builds grid view with tarot cards
class TaroCardsList extends StatefulWidget {
  final List<TaroCard> taroCards;
  const TaroCardsList({super.key, required this.taroCards});
  @override
  State createState() => _CardPageListState();
}

class _CardPageListState extends State<TaroCardsList> {
  InterstitialAd? _interstitialAd;
  late final Future<InterstitialAdLoader> _adLoader;
  int numberOfCardsOpened = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildTaroCards(),
    );
  }

  @override
  void initState() {
    super.initState();
    MobileAds.initialize();
    _adLoader = _createInterstitialAdLoader();
    _loadInterstitialAd();
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
                        fit: BoxFit.fitHeight,
                        child: Image.network(
                          widget.taroCards[index].imagePath,
                          errorBuilder: ((context, error, stackTrace) =>
                              const SizedBox()),
                        ),
                      )),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.taroCards[index].cardName,
                            style: Theme.of(context).textTheme.titleLarge)))
              ],
            ),
          ),
        );
      });

  Future<InterstitialAdLoader> _createInterstitialAdLoader() {
    return InterstitialAdLoader.create(
      onAdLoaded: (InterstitialAd interstitialAd) {
        // The ad was loaded successfully. Now you can show loaded ad
        _interstitialAd = interstitialAd;
      },
      onAdFailedToLoad: (error) {
        // Ad failed to load with AdRequestError.
        // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
      },
    );
  }

  Future<void> _loadInterstitialAd() async {
    final adLoader = await _adLoader;
    await adLoader.loadAd(
        adRequestConfiguration: const AdRequestConfiguration(
            adUnitId:
                'R-M-3620673-2')); // for debug you can use 'demo-interstitial-yandex'
  }
}
