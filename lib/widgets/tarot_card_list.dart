import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taro_cards/models/tarot_card.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import '../bloc/locale_bloc.dart';
import '../bloc/tarot_card_bloc.dart';
import '../bloc/tarot_card_event.dart';
import '../pages/card_page.dart';

///builds grid view with tarot cards
class TaroCardsList extends StatefulWidget {
  final List<TarotCard> taroCards;
  final TextEditingController editingController;

  const TaroCardsList(
      {super.key, required this.taroCards, required this.editingController});

  @override
  State createState() => _CardPageListState();
}

class _CardPageListState extends State<TaroCardsList> {
  InterstitialAd? _interstitialAd;
  late final Future<InterstitialAdLoader> _adLoader;
  static const _keyCards = 'numberOfCardsOpened';

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
          onTap: (() async {
            incrementCardsShown();
            final number = await getNumberOfCardsShown();
            if (number % 3 == 0) {
              _loadInterstitialAd();
              if (_interstitialAd != null) {
                _interstitialAd?.show();
              }
            }
            widget.editingController.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CardPage(cardId: widget.taroCards[index].cardId),
              ),
            );
            context.read<TarotCardBloc>().add(LoadTarotCardWithValues(
                widget.taroCards[index].cardId,
                context.read<LocaleBloc>().state.languageCode));
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
                          child: CachedNetworkImage(
                            imageUrl: widget.taroCards[index].imagePath,
                            errorWidget: (ctx, _, __) {
                              return SizedBox();
                            },
                          ))),
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

  ///creates an ad
  Future<InterstitialAdLoader> _createInterstitialAdLoader() {
    return InterstitialAdLoader.create(
      onAdLoaded: (InterstitialAd interstitialAd) {
        _interstitialAd = interstitialAd;
      },
    );
  }

  ///loads an ad
  Future<void> _loadInterstitialAd() async {
    final adLoader = await _adLoader;
    await adLoader.loadAd(
        adRequestConfiguration: const AdRequestConfiguration(
            adUnitId:
                'R-M-14552552-2')); // for debug you can use 'demo-interstitial-yandex'R-M-14552552-2
  }

  static Future<void> setNumberOfCardsShown(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCards, value);
  }

  static Future<int> getNumberOfCardsShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCards) ?? 0;
  }

  static Future<void> incrementCardsShown() async {
    final current = await getNumberOfCardsShown();
    await setNumberOfCardsShown(current + 1);
  }
}
