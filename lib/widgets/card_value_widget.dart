import 'package:flutter/material.dart';
import 'package:taro_cards/models/card_value.dart';
import 'package:taro_cards/widgets/source_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    if (widget.title == AppLocalizations.of(context).theGeneralMeaning)
      return Column(
        children: [
          Text(AppLocalizations.of(context).uprigth,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(widget.cardValues![0]!.upward,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18)),
          Text(AppLocalizations.of(context).reversed,
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
    if (widget.title == AppLocalizations.of(context).loveMeaning)
      return Column(
        children: [
          Text(AppLocalizations.of(context).uprigth,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(widget.cardValues![1]!.upward,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18)),
          Text(AppLocalizations.of(context).reversed,
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
    if (widget.title == AppLocalizations.of(context).situationOrQuestion)
      return Column(
        children: [
          Text(AppLocalizations.of(context).uprigth,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(widget.cardValues![2]!.upward,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18)),
          Text(AppLocalizations.of(context).reversed,
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
    if (widget.title == AppLocalizations.of(context).health)
      return Column(
        children: [
          Text(AppLocalizations.of(context).uprigth,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(widget.cardValues![6]!.upward,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18)),
          Text(AppLocalizations.of(context).reversed,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(widget.cardValues![6]!.downward,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18)),
        ],
      );
    if (widget.title == AppLocalizations.of(context).cardOfTheDay)
      return Column(
        children: [
          Text(widget.cardValues![3]!.upward,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18)),
        ],
      );
    if (widget.title == AppLocalizations.of(context).advice)
      return Column(children: [
        Text(widget.cardValues![4]!.upward,
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18)),
      ]);
    if (widget.title == AppLocalizations.of(context).yesOrNo)
      return Column(
        children: [
          Text(AppLocalizations.of(context).uprigth,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(widget.cardValues![5]!.upward,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18)),
          Text(AppLocalizations.of(context).reversed,
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
    else
      return Container();
  }
}
