/// Name of the database table that stores tarot cards.
const String tableTaroCards = 'TaroCards';

/// Contains column names used in the tarot cards database table.
///
/// Also provides predefined lists of fields for
/// localized and English-only queries.
class TarotCardsFields {
  /// All available table columns.
  static final List<String> values = [
    cardId,
    cardName,
    cardNameEn,
    category,
    categoryEn,
    upward,
    upwardEn,
    downward,
    downwardEn,
    imagePath,
  ];

  /// Subset of columns used for English localization.
  static final List<String> valuesEn = [
    cardId,
    cardNameEn,
    categoryEn,
    upwardEn,
    downwardEn,
    imagePath,
  ];

  /// Unique identifier of the tarot card.
  static const String cardId = 'cardId';

  /// Localized name of the card.
  static const String cardName = 'cardName';

  /// English name of the card.
  static const String cardNameEn = 'cardNameEn';

  /// Localized category of the card (e.g. Major Arcana).
  static const String category = 'category';

  /// English category of the card.
  static const String categoryEn = 'categoryEn';

  /// Localized upright meaning of the card.
  static const String upward = 'upward';

  /// Localized reversed meaning of the card.
  static const String downward = 'downward';

  /// English upright meaning of the card.
  static const String upwardEn = 'upwardEn';

  /// English reversed meaning of the card.
  static const String downwardEn = 'downwardEn';

  /// Path or URL to the tarot card image.
  static const String imagePath = 'imagePath';
}

/// Model representing a tarot card.
///
/// Contains basic card information, meanings,
/// and image reference.
class TarotCard {
  /// Unique identifier of the tarot card.
  final int cardId;

  /// Display name of the card.
  final String cardName;

  /// Category of the card (e.g. Major or Minor Arcana).
  final String category;

  /// Upright meaning of the card.
  final String upward;

  /// Reversed meaning of the card.
  final String downward;

  /// Path or URL to the card image.
  final String imagePath;

  const TarotCard({
    required this.cardId,
    required this.cardName,
    required this.category,
    required this.upward,
    required this.downward,
    required this.imagePath,
  });

  /// Converts this tarot card into a JSON-compatible map.
  ///
  /// Used for database storage or serialization.
  Map<String, Object?> toJson() => {
        TarotCardsFields.cardId: cardId,
        TarotCardsFields.cardName: cardName,
        TarotCardsFields.category: category,
        TarotCardsFields.upward: upward,
        TarotCardsFields.downward: downward,
        TarotCardsFields.imagePath: imagePath,
      };

  /// Creates a [TarotCard] instance from a JSON map.
  ///
  /// If a localized value is not available, the English
  /// fallback value is used instead.
  static TarotCard fromJson(Map<String, Object?> json) => TarotCard(
        cardId: json[TarotCardsFields.cardId] as int,
        cardName: json[TarotCardsFields.cardName] != null
            ? json[TarotCardsFields.cardName] as String
            : json[TarotCardsFields.cardNameEn] as String,
        category: json[TarotCardsFields.category] != null
            ? json[TarotCardsFields.category] as String
            : json[TarotCardsFields.categoryEn] as String,
        upward: json[TarotCardsFields.upward] != null
            ? json[TarotCardsFields.upward] as String
            : json[TarotCardsFields.upwardEn] as String,
        downward: json[TarotCardsFields.downward] != null
            ? json[TarotCardsFields.downward] as String
            : json[TarotCardsFields.downwardEn] as String,
        imagePath: json[TarotCardsFields.imagePath] as String,
      );

  /// Creates a copy of this tarot card with optional updated fields.
  ///
  /// Useful for immutability and state updates.
  TarotCard copy({
    int? id,
    String? cardName,
    String? category,
    String? upward,
    String? downward,
    String? imagePath,
  }) =>
      TarotCard(
        cardId: id ?? cardId,
        cardName: cardName ?? this.cardName,
        category: category ?? this.category,
        upward: upward ?? this.upward,
        downward: downward ?? this.downward,
        imagePath: imagePath ?? this.imagePath,
      );
}
