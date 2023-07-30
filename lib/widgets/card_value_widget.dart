import 'package:flutter/material.dart';
import 'package:taro_cards/models/card_value.dart';

///builds text with value of a card
class CardValueWidget extends StatefulWidget {
  final String title;
  final List<CardValue?>? cardValues;
  const CardValueWidget({Key? key, required this.title, required this.cardValues})
      : super(key: key);
  @override
  _CardValueWidgetState createState() => _CardValueWidgetState();
}

class _CardValueWidgetState extends State<CardValueWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.title) {
      case "Общее значение":
        return Column(
          children: [
            Text("Прямое положение: ",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![0]!.upward,
                style: Theme.of(context).textTheme.headline6),
            Text("Обратное положение: ",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![0]!.downward,
                style: Theme.of(context).textTheme.headline6),
          ],
        );
      case "Значение в любви и отношениях":
        return Column(
          children: [
            Text("Прямое положение: ",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![1]!.upward,
                style: Theme.of(context).textTheme.headline6),
            Text("Обратное положение: ",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![1]!.downward,
                style: Theme.of(context).textTheme.headline6),
          ],
        );
      case "В ситуации и вопросе":
        return Column(
          children: [
            Text("Прямое положение: ",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![2]!.upward,
                style: Theme.of(context).textTheme.headline6),
            Text("Обратное положение: ",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![2]!.downward,
                style: Theme.of(context).textTheme.headline6),
          ],
        );
      case "Значение карты дня":
        return Column(
          children: [
            Text(widget.cardValues![2]!.upward,
                style: Theme.of(context).textTheme.headline6),
          ],
        );
      case "Совет карты":
        return Column(children: [
          Text(widget.cardValues![4]!.upward,
              style: Theme.of(context).textTheme.headline6),
        ]);
      default:
        return Container();
    }
  }
}
