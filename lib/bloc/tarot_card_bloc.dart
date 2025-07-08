import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/card_value.dart';
import '../models/tarot_card.dart';
import 'tarot_card_event.dart';
import 'tarot_card_state.dart';
import '../repositories/tarot_card_repository.dart';

///bloc for tarot cards
class TarotCardBloc extends Bloc<TarotCardEvent, TarotCardState> {
  final TarotCardRepository repository;

  TarotCardBloc(this.repository) : super(TarotCardInitial()) {
    on<LoadTarotCardWithValues>(_onLoadCardWithValues);
    on<LoadCardCombination>(_onLoadCombination);
    on<LoadCardsByCategory>(_onLoadCardsByCategory);
    on<TarotChangeLocale>(_onChangeLocale);
  }

  Future<void> _onLoadCardWithValues(
    LoadTarotCardWithValues event,
    Emitter<TarotCardState> emit,
  ) async {
    emit(TarotCardLoading());

    try {
      final cardFuture = repository.readTarotCard(event.id, event.locale);
      final valuesFuture =
          repository.readTarotCardValues(event.id, event.locale);

      // параллельная загрузка
      final results = await Future.wait([cardFuture, valuesFuture]);

      final card = results[0] as TarotCard?;
      final values = results[1] as List<CardValue>;

      if (card == null) {
        emit(TarotCardError('Карта не найдена'));
        return;
      }

      emit(TarotCardDetailFullLoaded(card, values));
    } catch (e) {
      emit(TarotCardError('Ошибка загрузки: $e'));
    }
  }

  Future<void> _onLoadCombination(
    LoadCardCombination event,
    Emitter<TarotCardState> emit,
  ) async {
    emit(TarotCardLoading());
    try {
      final combo = await repository.readCombination(
          event.firstCard, event.secondCard, event.locale);
      emit(TarotCardCombinationLoaded(combo));
    } catch (e) {
      emit(TarotCardError('Ошибка загрузки комбинации: $e'));
    }
  }

  Future<void> _onLoadCardsByCategory(
    LoadCardsByCategory event,
    Emitter<TarotCardState> emit,
  ) async {
    emit(TarotCardLoading());
    try {
      final cards =
          await repository.readAllCardsByCategory(event.category, event.locale);
      emit(TarotCardsLoaded(cards));
    } catch (e) {
      emit(TarotCardError('Ошибка загрузки по категории: $e'));
    }
  }

  Future<void> _onChangeLocale(
    TarotChangeLocale event,
    Emitter<TarotCardState> emit,
  ) async {
    emit(TarotCardLoading());

    try {
      final cards =
          await repository.readAllCardsByCategory(event.category, event.locale);

      emit(TarotCardsLoaded(cards));
    } catch (e) {
      emit(TarotCardError("Ошибка смены локали: $e"));
    }
  }
}
