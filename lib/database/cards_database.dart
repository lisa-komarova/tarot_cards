import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:taro_cards/models/card_combination.dart';
import '../models/card_value.dart';
import '../models/tarot_card.dart';

///database with tarot cards, its values and combinations
class TarotCardsDatabase {
  static final TarotCardsDatabase instance = TarotCardsDatabase._internal();

  factory TarotCardsDatabase() => instance;

  TarotCardsDatabase._internal();

  Database? _db;

  ///initializes the database
  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'cards.db');
    await deleteDatabase(path);
    ByteData data = await rootBundle.load("assets/cards.db");
    List<int> bytes =
        await data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
    _db = await openDatabase(
      path,
      version: 1,
    );
  }

  ///gets an instance of a database
  Future<Database> get database async {
    if (_db == null) {
      throw Exception('Database not initialized. Call init(locale) first.');
    }
    return _db!;
  }

  ///gets tarot card by id
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

  ///gets tarot card's values by id
  Future<List<CardValue?>> readTarotCardValues(int id, String locale) async {
    final db = await database;
    List<dynamic> whereArguments = [id];
    final result = await db.query(
      tableCardValues,
      columns:
          locale == 'ru' ? CardValuesFields.values : CardValuesFields.valuesEn,
      where: '${CardValuesFields.cardId} = ?',
      whereArgs: whereArguments,
    );
    return result.map((json) => CardValue.fromJson(json)).toList();
  }

  ///gets all taro cards
  Future<List<TarotCard>> readAllTaroCards(String locale) async {
    final db = await database;
    final result = await db.query(
      tableTaroCards,
      columns:
          locale == 'ru' ? TarotCardsFields.values : TarotCardsFields.valuesEn,
    );
    return result.map((json) => TarotCard.fromJson(json)).toList();
  }

  ///gets the meaning of combination of two cards
  Future<CardCombination?> readCombination(
      TarotCard firstCard, TarotCard secondCard, String locale) async {
    final db = await database;
    List<dynamic> whereArguments = [firstCard.cardId, secondCard.cardId];
    final result = await db.query(
      tableCardCombination,
      columns: locale == 'ru'
          ? CardCombinationFields.values
          : CardCombinationFields.valuesEn,
      where:
          '${CardCombinationFields.firstCardId} = ? and ${CardCombinationFields.secondCardId} = ?',
      whereArgs: whereArguments,
    );
    if (result.isNotEmpty) {
      return CardCombination.fromJson(result.first);
    } else {
      return null;
    }
  }

  ///gets all cards by category
  Future<List<TarotCard>> readAllCardsByCategory(
      String category, String locale) async {
    final db = await database;
    String whereString =
        '${locale == 'ru' ? TarotCardsFields.category : TarotCardsFields.categoryEn} = ?';
    List<dynamic> whereArguments = [category];
    final result = await db.query(tableTaroCards,
        columns: locale == 'ru'
            ? TarotCardsFields.values
            : TarotCardsFields.valuesEn,
        where: whereString,
        whereArgs: whereArguments);
    return result.map((json) => TarotCard.fromJson(json)).toList();
  }

  //closes db
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
