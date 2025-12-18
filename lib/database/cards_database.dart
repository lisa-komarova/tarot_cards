import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:taro_cards/models/card_combination.dart';
import '../models/card_value.dart';
import '../models/spread_card_interpretation.dart';
import '../models/tarot_card.dart';

/// Singleton class that manages the Tarot cards database.
///
/// Handles initialization, queries, and closing of the database.
/// Stores tarot cards, their values, combinations, and yearly readings.
class TarotCardsDatabase {
  /// Single shared instance of [TarotCardsDatabase].
  static final TarotCardsDatabase instance = TarotCardsDatabase._internal();

  factory TarotCardsDatabase() => instance;

  TarotCardsDatabase._internal();

  Database? _db;

  /// Initializes the database by copying it from assets if needed.
  ///
  /// Deletes any existing database at the path and replaces it
  /// with the bundled `cards.db` from assets.
  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'cards.db');

    // Remove existing database
    await deleteDatabase(path);

    // Load database from assets
    ByteData data = await rootBundle.load("assets/cards.db");
    List<int> bytes =
        await data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes);

    // Open the database
    _db = await openDatabase(
      path,
      version: 1,
    );
  }

  /// Returns an initialized database instance.
  ///
  /// Throws an [Exception] if `init()` was not called first.
  Future<Database> get database async {
    if (_db == null) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _db!;
  }

  /// Retrieves a tarot card by its [id].
  ///
  /// [locale] determines whether Russian or English columns are used.
  Future<TarotCard?> readTarotCard(int id, String locale) async {
    final db = await database;
    final maps = await db.query(
      tableTaroCards,
      columns:
          locale == 'ru' ? TarotCardsFields.values : TarotCardsFields.valuesEn,
      where: '${TarotCardsFields.cardId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TarotCard.fromJson(maps.first);
    } else {
      return null;
    }
  }

  /// Retrieves all values (meanings) for a specific tarot card.
  ///
  /// [id] is the card ID, [locale] determines language selection.
  Future<List<CardValue?>> readTarotCardValues(int id, String locale) async {
    final db = await database;
    final result = await db.query(
      tableCardValues,
      columns:
          locale == 'ru' ? CardValuesFields.values : CardValuesFields.valuesEn,
      where: '${CardValuesFields.cardId} = ?',
      whereArgs: [id],
    );
    return result.map((json) => CardValue.fromJson(json)).toList();
  }

  /// Retrieves all tarot cards.
  ///
  /// [locale] determines whether Russian or English columns are used.
  Future<List<TarotCard>> readAllTaroCards(String locale) async {
    final db = await database;
    final result = await db.query(
      tableTaroCards,
      columns:
          locale == 'ru' ? TarotCardsFields.values : TarotCardsFields.valuesEn,
    );
    return result.map((json) => TarotCard.fromJson(json)).toList();
  }

  /// Retrieves the meaning of a combination of two tarot cards.
  ///
  /// [firstCard] and [secondCard] are the cards to combine,
  /// [locale] determines language selection.
  Future<CardCombination?> readCombination(
      TarotCard firstCard, TarotCard secondCard, String locale) async {
    final db = await database;
    final result = await db.query(
      tableCardCombination,
      columns: locale == 'ru'
          ? CardCombinationFields.values
          : CardCombinationFields.valuesEn,
      where:
          '${CardCombinationFields.firstCardId} = ? AND ${CardCombinationFields.secondCardId} = ?',
      whereArgs: [firstCard.cardId, secondCard.cardId],
    );
    if (result.isNotEmpty) {
      return CardCombination.fromJson(result.first);
    } else {
      return null;
    }
  }

  /// Retrieves a yearly reading for a specific card.
  ///
  /// Returns a list of [SpreadCardInterpretation] objects for each position in the year spread.
  Future<List<SpreadCardInterpretation>?> readYearReading(
      int cardId, String locale) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT ${locale == 'ru' ? 'p.title' : 'p.titleEn'} AS positionId, '
        '${locale == 'ru' ? 'i.text' : 'i.textEn'} '
        'FROM SpreadCardInterpretations i '
        'JOIN SpreadPositions p '
        'WHERE cardId = $cardId AND i.positionId = p.positionId');
    if (result.isNotEmpty) {
      return result
          .map((json) => SpreadCardInterpretation.fromJson(json))
          .toList();
    } else {
      return null;
    }
  }

  /// Retrieves all cards belonging to a specific category.
  ///
  /// [category] is the name of the category (e.g., "Major Arcana"),
  /// [locale] determines the language of the column used for filtering.
  Future<List<TarotCard>> readAllCardsByCategory(
      String category, String locale) async {
    final db = await database;
    final whereString =
        '${locale == 'ru' ? TarotCardsFields.category : TarotCardsFields.categoryEn} = ?';
    final result = await db.query(
      tableTaroCards,
      columns:
          locale == 'ru' ? TarotCardsFields.values : TarotCardsFields.valuesEn,
      where: whereString,
      whereArgs: [category],
    );
    return result.map((json) => TarotCard.fromJson(json)).toList();
  }

  /// Closes the database.
  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
