import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taro_cards/models/card_value.dart';
import 'package:taro_cards/models/tarot_card.dart';
import 'package:taro_cards/widgets/card_value_widget.dart';

import '../bloc/locale_bloc.dart';
import '../database/cards_database.dart';

///widget for showing and hiding value of a card
class CardValueButtonAnimated extends StatefulWidget {
  ///situation in which card is read (meaning in love, card of a day etc)
  final String title;
  final TarotCard taroCard;
  const CardValueButtonAnimated(
      {super.key, required this.title, required this.taroCard});
  @override
  State createState() => _CardValueButtonAnimatedState();
}

class _CardValueButtonAnimatedState extends State<CardValueButtonAnimated>
    with SingleTickerProviderStateMixin {
  static const _color = Colors.white;
  bool isLoading = true;
  List<CardValue?>? cardValues = [];
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  ///controls whether the value is shown
  void _toggleCard() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    getTaroCardValue();
  }

  ///reads values of a card (meaning in love, card of a day etc)
  Future getTaroCardValue() async {
    setState(() => isLoading = true);

    cardValues = (await TarotCardsDatabase.instance.readTarotCardValues(
        widget.taroCard.cardId, context.read<LocaleBloc>().state.languageCode));

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: _toggleCard,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _color.withOpacity(
                    lerpDouble(1, 0.4, _controller.value)!,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Transform.rotate(
                      angle: pi * _controller.value,
                      child: const Icon(
                        Icons.arrow_drop_up,
                        color: Color(0xFF5E017D),
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
          axisAlignment: -1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? const CircularProgressIndicator()
                : CardValueWidget(
                    title: widget.title,
                    cardValues: cardValues,
                  ),
          ),
        ),
      ],
    );
  }
}
