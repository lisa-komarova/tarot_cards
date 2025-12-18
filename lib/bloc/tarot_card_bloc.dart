import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/card_value.dart';
import '../models/tarot_card.dart';
import 'tarot_card_event.dart';
import 'tarot_card_state.dart';
import '../repositories/tarot_card_repository.dart';

/// Bloc that handles tarot card data, including loading cards,
/// card values, card combinations, and updating the locale.
class TarotCardBloc extends Bloc<TarotCardEvent, TarotCardState> {
  /// Repository used to fetch tarot card data
  final TarotCardRepository repository;

  /// Creates a [TarotCardBloc] with the given [repository].
  ///
  /// Registers event handlers for loading cards, combinations,
  /// categories, and changing locale.
  TarotCardBloc(this.repository) : super(TarotCardInitial()) {
    on<LoadTarotCardWithValues>(_onLoadCardWithValues);
    on<LoadCardCombination>(_onLoadCombination);
    on<LoadCardsByCategory>(_onLoadCardsByCategory);
    on<TarotChangeLocale>(_onChangeLocale);
  }

  /// Handles loading a tarot card along with its values.
  ///
  /// Emits [TarotCardLoading] before loading,
  /// then emits [TarotCardDetailFullLoaded] with the card and values
  /// if successful, or [TarotCardError] if the card is not found or an error occurs.
  Future<void> _onLoadCardWithValues(LoadTarotCardWithValues event,
      Emitter<TarotCardState> emit,) async {
    emit(TarotCardLoading());

    try {
      final cardFuture = repository.readTarotCard(event.id, event.locale);
      final valuesFuture =
          repository.readTarotCardValues(event.id, event.locale);

      // Parallel loading
      final results = await Future.wait([cardFuture, valuesFuture]);

      final card = results[0] as TarotCard?;
      final values = results[1] as List<CardValue>;

      if (card == null) {
        emit(TarotCardError('Card not found'));
        return;
      }

      emit(TarotCardDetailFullLoaded(card, values));
    } catch (e) {
      emit(TarotCardError('Error loading card: $e'));
    }
  }

  /// Handles loading the meaning of a combination of two cards.
  ///
  /// Emits [TarotCardLoading] before loading,
  /// then emits [TarotCardCombinationLoaded] if successful,
  /// or [TarotCardError] if an error occurs.
  Future<void> _onLoadCombination(LoadCardCombination event,
      Emitter<TarotCardState> emit,) async {
    emit(TarotCardLoading());
    try {
      final combo = await repository.readCombination(
          event.firstCard, event.secondCard, event.locale);
      emit(TarotCardCombinationLoaded(combo));
    } catch (e) {
      emit(TarotCardError('Error loading combination: $e'));
    }
  }

  /// Handles loading all cards of a specific category.
  ///
  /// Emits [TarotCardLoading] before loading,
  /// then emits [TarotCardsLoaded] with the list of cards if successful,
  /// or [TarotCardError] if an error occurs.
  Future<void> _onLoadCardsByCategory(LoadCardsByCategory event,
      Emitter<TarotCardState> emit,) async {
    emit(TarotCardLoading());
    try {
      final cards =
          await repository.readAllCardsByCategory(event.category, event.locale);
      emit(TarotCardsLoaded(cards));
    } catch (e) {
      emit(TarotCardError('Error loading cards by category: $e'));
    }
  }

  /// Handles changing the locale (language) for tarot cards.
  ///
  /// Emits [TarotCardLoading] before loading,
  /// then emits [TarotCardsLoaded] with the updated cards if successful,
  /// or [TarotCardError] if an error occurs.
  Future<void> _onChangeLocale(TarotChangeLocale event,
      Emitter<TarotCardState> emit,) async {
    emit(TarotCardLoading());

    try {
      final cards =
          await repository.readAllCardsByCategory(event.category, event.locale);

      emit(TarotCardsLoaded(cards));
    } catch (e) {
      emit(TarotCardError("Error changing locale: $e"));
    }
  }
}
