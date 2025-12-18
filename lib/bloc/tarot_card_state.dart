import 'package:equatable/equatable.dart';
import '../models/card_combination.dart';
import '../models/card_value.dart';
import '../models/tarot_card.dart';

/// Base state for TarotCardBloc.
///
/// All states extend this class. Uses [Equatable] for value equality.
abstract class TarotCardState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Initial state of the TarotCardBloc.
///
/// Indicates that nothing has been loaded yet.
class TarotCardInitial extends TarotCardState {}

/// State indicating that tarot card data is being loaded.
///
/// Can be used to show loading indicators.
class TarotCardLoading extends TarotCardState {}

/// State representing a list of loaded tarot cards.
///
/// Contains [cards], a list of [TarotCard] objects.
class TarotCardsLoaded extends TarotCardState {
  final List<TarotCard> cards;

  TarotCardsLoaded(this.cards);

  @override
  List<Object> get props => [cards];
}

/// State representing a single tarot card with full details.
///
/// Contains [card] and its associated [values].
class TarotCardDetailFullLoaded extends TarotCardState {
  final TarotCard card;
  final List<CardValue> values;

  TarotCardDetailFullLoaded(this.card, this.values);
}

/// State representing the meaning of a combination of two cards.
///
/// Contains [combination], a [CardCombination] object or null if not found.
class TarotCardCombinationLoaded extends TarotCardState {
  final CardCombination? combination;

  TarotCardCombinationLoaded(this.combination);
}

/// State representing an error in tarot card operations.
///
/// Contains [message], a description of the error.
class TarotCardError extends TarotCardState {
  final String message;

  TarotCardError(this.message);

  @override
  List<Object> get props => [message];
}
