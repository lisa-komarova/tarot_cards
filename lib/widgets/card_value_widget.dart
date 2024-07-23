import 'package:flutter/material.dart';
import 'package:taro_cards/models/card_value.dart';
import 'package:taro_cards/widgets/source_widget.dart';

///builds text with the value of a card
class CardValueWidget extends StatefulWidget {
  final String title;
  final List<CardValue?>? cardValues;
  const CardValueWidget(
      {super.key, required this.title, required this.cardValues});
  @override
  State createState() => _CardValueWidgetState();
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
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![0]!.upward,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18)),
            Text("Обратное положение: ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![0]!.downward,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18)),
          ],
        );
      case "Значение в любви и отношениях":
        return Column(
          children: [
            Text("Прямое положение: ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![1]!.upward,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18)),
            Text("Обратное положение: ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![1]!.downward,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18)),
          ],
        );
      case "В ситуации и вопросе":
        return Column(
          children: [
            Text("Прямое положение: ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![2]!.upward,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18)),
            Text("Обратное положение: ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![2]!.downward,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18)),
          ],
        );
      case "Значение карты дня":
        return Column(
          children: [
            Text(widget.cardValues![3]!.upward,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18)),
          ],
        );
      case "Совет карты":
        return Column(children: [
          Text(widget.cardValues![4]!.upward,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18)),
        ]);
      case "Значение да/нет":
        return Column(
          children: [
            Text("Прямое положение: ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![5]!.upward,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18)),
            Text("Обратное положение: ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(widget.cardValues![5]!.downward,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18)),
            const SizedBox(
              height: 10,
            ),
            const SourceWidget(
              url: 'https://magya-online.ru/',
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
