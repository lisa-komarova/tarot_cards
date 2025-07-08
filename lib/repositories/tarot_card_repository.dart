import 'package:taro_cards/models/card_value.dart';

import '../database/cards_database.dart';
import '../models/card_combination.dart';
import '../models/tarot_card.dart';

/// repository for working with Tarot cards
/// provides methods to retrieve, store, and update Tarot card data
class TarotCardRepository {
  final TarotCardsDatabase _dbHelper = TarotCardsDatabase();

  Future<TarotCard?> readTarotCard(int id, String locale) {
    return _dbHelper.readTarotCard(id, locale);
  }

  Future<List<CardValue?>> readTarotCardValues(int id, String locale) {
    return _dbHelper.readTarotCardValues(id, locale);
  }

  Future<CardCombination?> readCombination(
      TarotCard firstCard, TarotCard secondCard, String locale) {
    return _dbHelper.readCombination(firstCard, secondCard, locale);
  }

  Future<List<TarotCard>> readAllCardsByCategory(
      String category, String locale) {
    return _dbHelper.readAllCardsByCategory(category, locale);
  }
}
