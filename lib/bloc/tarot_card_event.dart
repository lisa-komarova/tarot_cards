import 'package:equatable/equatable.dart';
import 'package:taro_cards/models/tarot_card.dart';

abstract class TarotCardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTarotCardWithValues extends TarotCardEvent {
  final int id;
  final String locale;

  LoadTarotCardWithValues(this.id, this.locale);
}

class LoadCardCombination extends TarotCardEvent {
  final TarotCard firstCard;
  final TarotCard secondCard;
  final String locale;

  LoadCardCombination(this.firstCard, this.secondCard, this.locale);
}

class LoadCardsByCategory extends TarotCardEvent {
  final String category;
  final String locale;

  LoadCardsByCategory(this.category, this.locale);
}

class TarotChangeLocale extends TarotCardEvent {
  final String locale;
  final String category;

  TarotChangeLocale({required this.locale, required this.category});
}
