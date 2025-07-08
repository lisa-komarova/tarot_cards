import 'package:equatable/equatable.dart';
import '../models/card_combination.dart';
import '../models/card_value.dart';
import '../models/tarot_card.dart';

abstract class TarotCardState extends Equatable {
  @override
  List<Object> get props => [];
}

class TarotCardInitial extends TarotCardState {}

class TarotCardLoading extends TarotCardState {}

class TarotCardsLoaded extends TarotCardState {
  final List<TarotCard> cards;

  TarotCardsLoaded(this.cards);

  @override
  List<Object> get props => [cards];
}

class TarotCardDetailFullLoaded extends TarotCardState {
  final TarotCard card;
  final List<CardValue> values;

  TarotCardDetailFullLoaded(this.card, this.values);
}

class TarotCardCombinationLoaded extends TarotCardState {
  final CardCombination? combination;

  TarotCardCombinationLoaded(this.combination);
}

class TarotCardError extends TarotCardState {
  final String message;

  TarotCardError(this.message);

  @override
  List<Object> get props => [message];
}
