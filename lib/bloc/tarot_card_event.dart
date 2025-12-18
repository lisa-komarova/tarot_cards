import 'package:equatable/equatable.dart';
import 'package:taro_cards/models/tarot_card.dart';

/// Base event class for TarotCardBloc.
///
/// All events extend this class. Uses [Equatable] for value equality.
abstract class TarotCardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event to load a tarot card along with its values.
///
/// [id] is the ID of the tarot card to load.
/// [locale] specifies the language for the card and values.
class LoadTarotCardWithValues extends TarotCardEvent {
  final int id;
  final String locale;

  LoadTarotCardWithValues(this.id, this.locale);
}

/// Event to load the meaning of a combination of two cards.
///
/// [firstCard] and [secondCard] are the cards in the combination.
/// [locale] specifies the language for the combination meaning.
class LoadCardCombination extends TarotCardEvent {
  final TarotCard firstCard;
  final TarotCard secondCard;
  final String locale;

  LoadCardCombination(this.firstCard, this.secondCard, this.locale);
}

/// Event to load all tarot cards for a specific category.
///
/// [category] is the category of cards (e.g., Major Arcana, Wands).
/// [locale] specifies the language for the cards.
class LoadCardsByCategory extends TarotCardEvent {
  final String category;
  final String locale;

  LoadCardsByCategory(this.category, this.locale);
}

/// Event to change the locale (language) for tarot cards.
///
/// [locale] is the new language code (e.g., 'en', 'ru').
/// [category] specifies the current category to refresh.
class TarotChangeLocale extends TarotCardEvent {
  final String locale;
  final String category;

  TarotChangeLocale({required this.locale, required this.category});
}
