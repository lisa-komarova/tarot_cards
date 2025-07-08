import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taro_cards/bloc/tarot_card_event.dart';
import 'package:taro_cards/bloc/tarot_card_state.dart';
import 'package:taro_cards/models/card_value.dart';
import 'package:taro_cards/models/tarot_card.dart';
import 'package:taro_cards/widgets/ad_widget.dart';
import 'package:taro_cards/widgets/card_value_button_animated.dart';
import 'package:taro_cards/widgets/combination_widget.dart';
import 'package:taro_cards/widgets/source_widget.dart';

import '../bloc/locale_bloc.dart';
import '../bloc/tarot_card_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///cardpage widget is for displaying tarot card and its values
class CardPage extends StatefulWidget {
  ///tarot card id
  final int cardId;

  const CardPage({super.key, required this.cardId});
  @override
  State createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late TarotCard taroCard;
  late CardValue cardValue;

  @override
  void initState() {
    super.initState();
    // getTaroCard();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<TarotCardBloc>().add(LoadCardsByCategory(
            taroCard.category, context.read<LocaleBloc>().state.languageCode));
        Navigator.of(context).pop();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          width: double.infinity,
          child: BlocBuilder<TarotCardBloc, TarotCardState>(
              builder: (context, state) {
            if (state is TarotCardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TarotCardDetailFullLoaded) {
              taroCard = state.card;
              return buildTaroCard();
            } else {
              return SizedBox.shrink();
            }
          }),
        ),
      ),
    );
  }

  ///reads tarot card from db
  Future getTaroCard() async {
    context.read<TarotCardBloc>().add(LoadTarotCardWithValues(
        widget.cardId, context.read<LocaleBloc>().state.languageCode));
    //taroCard = (await TarotCardsDatabase().readTarotCard(widget.cardId))!;
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
          BannerAdvertisement(
            screenWidth: MediaQuery.of(context).size.width.round(),
          ),
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
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 345,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCardCharacteristic(
                                AppLocalizations.of(context).cardName,
                                taroCard.cardName),
                            _buildCardCharacteristic(
                                AppLocalizations.of(context).category,
                                taroCard.category),
                            if (taroCard.category ==
                                AppLocalizations.of(context).majorArcana)
                              _buildCardCharacteristic(
                                  AppLocalizations.of(context).number,
                                  (taroCard.cardId - 1).toString()),
                            _buildCardCharacteristic(
                                AppLocalizations.of(context).uprigthCapital,
                                taroCard.upward),
                            _buildCardCharacteristic(
                                AppLocalizations.of(context).reversedCapital,
                                taroCard.downward),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              CardValueButtonAnimated(
                title: AppLocalizations.of(context).theGeneralMeaning,
                taroCard: taroCard,
              ),
              CardValueButtonAnimated(
                title: AppLocalizations.of(context).loveMeaning,
                taroCard: taroCard,
              ),
              CardValueButtonAnimated(
                title: AppLocalizations.of(context).situationOrQuestion,
                taroCard: taroCard,
              ),
              CardValueButtonAnimated(
                title: AppLocalizations.of(context).health,
                taroCard: taroCard,
              ),
              CardValueButtonAnimated(
                title: AppLocalizations.of(context).cardOfTheDay,
                taroCard: taroCard,
              ),
              CardValueButtonAnimated(
                title: AppLocalizations.of(context).advice,
                taroCard: taroCard,
              ),
              CardValueButtonAnimated(
                title: AppLocalizations.of(context).yesOrNo,
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
  Widget _buildCardCharacteristic(String characteristic, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: Text(
            characteristic,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Text(value, style: Theme.of(context).textTheme.bodyMedium!),
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
                    fit: BoxFit.fitHeight,
                    child: CachedNetworkImage(
                      imageUrl: taroCard.imagePath,
                      errorWidget: (context, url, error) => const SizedBox(),
                    ))),
          ),
          Container(
              padding: const EdgeInsets.only(left: 10, bottom: 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(taroCard.cardName,
                      style: Theme.of(context).textTheme.titleLarge))),
        ],
      ),
    );
  }
}
