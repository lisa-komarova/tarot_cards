import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taro_cards/models/card_combination.dart';
import '../models/card_value.dart';
import '../models/taro_card.dart';

class TaroCardsDatabase {
  static final TaroCardsDatabase instance = TaroCardsDatabase._init();
  static Database? _database;
  TaroCardsDatabase._init();

  ///gets an instance of a datebase
  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("cards.db");
    return _database;
  }

  ///initializes datebase
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    await deleteDatabase(path);
    ByteData data = await rootBundle.load("assets/cards.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
    return await openDatabase(path, version: 1);
  }

  ///gets taro card by id
  Future<TaroCard?> readTaroCard(int id) async {
    final db = await instance.database;
    final maps = await db!.query(
      tableTaroCards,
      columns: TaroCardsFields.values,
      where: '${TaroCardsFields.cardId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TaroCard.fromJson(maps.first);
    } else {
      return null;
    }
  }

  ///gets taro card's values by id
  Future<List<CardValue?>> readTaroCardValues(int id) async {
    final db = await instance.database;
    List<dynamic> whereArguments = [id];
    final result = await db!.query(
      tableCardValues,
      where: '${CardValuesFields.cardId} = ?',
      whereArgs: whereArguments,
    );
    return result.map((json) => CardValue.fromJson(json)).toList();
  }

  ///gets all taro cards
  Future<List<TaroCard>> readAllTaroCards() async {
    final db = await instance.database;
    final result = await db!.query(
      tableTaroCards,
    );
    return result.map((json) => TaroCard.fromJson(json)).toList();
  }

  ///gets the meaning of combination of two cards
  Future<CardCombintaion?> readCombination(
      TaroCard firstCard, TaroCard secondCard) async {
    final db = await instance.database;
    List<dynamic> whereArguments = [firstCard.cardId, secondCard.cardId];
    final result = await db!.query(
      tableCardCombination,
      where:
          '${CardCombinationFields.firstCardId} = ? and ${CardCombinationFields.secondCardId} = ?',
      whereArgs: whereArguments,
    );
    if (result.isNotEmpty) {
      return CardCombintaion.fromJson(result.first);
    } else {
      return null;
    }
  }

  ///gets all major arcana cards
  Future<List<TaroCard>> readAllMajorArcana() async {
    final db = await instance.database;
    String whereString = '${TaroCardsFields.category} = ?';
    String category = "Старшие арканы";
    List<dynamic> whereArguments = [category];
    final result = await db!
        .query(tableTaroCards, where: whereString, whereArgs: whereArguments);
    return result.map((json) => TaroCard.fromJson(json)).toList();
  }

  ///gets all wands cards
  Future<List<TaroCard>> readAllWands() async {
    final db = await instance.database;
    String whereString = '${TaroCardsFields.category} = ?';
    String category = "Жезлы";
    List<dynamic> whereArguments = [category];
    final result = await db!
        .query(tableTaroCards, where: whereString, whereArgs: whereArguments);
    return result.map((json) => TaroCard.fromJson(json)).toList();
  }

  ///gets all cups cards
  Future<List<TaroCard>> readAllCups() async {
    final db = await instance.database;
    String whereString = '${TaroCardsFields.category} = ?';
    String category = "Кубки";
    List<dynamic> whereArguments = [category];
    final result = await db!
        .query(tableTaroCards, where: whereString, whereArgs: whereArguments);
    return result.map((json) => TaroCard.fromJson(json)).toList();
  }

  ///gets all swords cards
  Future<List<TaroCard>> readAllSwords() async {
    final db = await instance.database;
    String whereString = '${TaroCardsFields.category} = ?';
    String category = "Мечи";
    List<dynamic> whereArguments = [category];
    final result = await db!
        .query(tableTaroCards, where: whereString, whereArgs: whereArguments);
    return result.map((json) => TaroCard.fromJson(json)).toList();
  }

  ///gets all pentacles cards
  Future<List<TaroCard>> readAllPentacles() async {
    final db = await instance.database;
    String whereString = '${TaroCardsFields.category} = ?';
    String category = "Пентакли";
    List<dynamic> whereArguments = [category];
    final result = await db!
        .query(tableTaroCards, where: whereString, whereArgs: whereArguments);
    return result.map((json) => TaroCard.fromJson(json)).toList();
  }

  //closes db
  Future close() async {
    final db = await instance.database;
    db!.close();
  }
}
