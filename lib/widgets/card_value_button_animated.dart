import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taro_cards/models/card_value.dart';
import 'package:taro_cards/models/taro_card.dart';
import 'package:taro_cards/widgets/card_value_widget.dart';

import '../database/cards_database.dart';

///widget for showing and hiding value of a card
class CardValueButtonAnimated extends StatefulWidget {
  ///situation in which card is read (meaning in love, card of a day etc)
  final String title;
  final TaroCard taroCard;
  const CardValueButtonAnimated(
      {super.key, required this.title, required this.taroCard});
  @override
  State createState() => _CardValueButtonAnimatedState();
}

class _CardValueButtonAnimatedState extends State<CardValueButtonAnimated>
    with SingleTickerProviderStateMixin {
  static const _color = Colors.white;

  late final _controller = AnimationController(vsync: this);
  bool visibility = false;
  bool isLoading = true;
  List<CardValue?>? cardValues = [];

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
                alignment: Alignment.center,
                width: double.infinity,
                height: 60,
                decoration: DecorationTween(
                  begin: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: _color,
                  ),
                  end: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: _color.withOpacity(0.4),
                  ),
                ).evaluate(_controller),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    )),
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
