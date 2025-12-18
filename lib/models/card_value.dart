/// Name of the database table that stores the values/meanings of tarot cards.
const String tableCardValues = 'CardValue';

/// Contains column names used in the CardValue table.
///
/// Provides lists of fields for general and English-only queries.
class CardValuesFields {
  /// All available table columns.
  static final List<String> values = [
    cardValueId,
    valueName,
    cardId,
    upward,
    downward,
  ];

  /// Subset of columns used for English localization.
  static final List<String> valuesEn = [
    cardValueId,
    valueNameEn,
    cardId,
    upwardEn,
    downwardEn,
  ];

  /// Unique identifier of the card value record.
  static const cardValueId = 'cardValueId';

  /// Name of the value/situation (e.g., Love, Health).
  static const valueName = 'valueName';

  /// Name of the value/situation in English.
  static const valueNameEn = 'valueNameEn';

  /// Foreign key linking to a tarot card.
  static const cardId = 'cardID';

  /// Meaning of the card in an upright position.
  static const upward = 'upward';

  /// Meaning of the card in a reversed position.
  static const downward = 'downward';

  /// Meaning of the card in an upright position (English).
  static const upwardEn = 'upwardEn';

  /// Meaning of the card in a reversed position (English).
  static const downwardEn = 'downwardEn';
}

/// Model representing the meaning of a tarot card in different situations.
///
/// Contains the upright and reversed meanings for a specific card and context.
class CardValue {
  /// Unique identifier of this card value.
  final int cardValueId;

  /// Name of the value/situation (e.g., Love, Health).
  final String valueName;

  /// Foreign key linking to a tarot card.
  final int cardId;

  /// Meaning of the card in an upright position.
  final String upward;

  /// Meaning of the card in a reversed position.
  final String downward;

  const CardValue({
    required this.cardValueId,
    required this.valueName,
    required this.cardId,
    required this.upward,
    required this.downward,
  });

  /// Converts this card value into a JSON-compatible map.
  ///
  /// Useful for database storage or serialization.
  Map<String, Object?> toJson() => {
        CardValuesFields.cardValueId: cardValueId,
        CardValuesFields.cardId: cardId,
        CardValuesFields.valueName: valueName,
        CardValuesFields.upward: upward,
        CardValuesFields.downward: downward,
      };

  /// Creates a [CardValue] instance from a JSON map.
  ///
  /// Uses English fallback if the localized text is not available.
  static CardValue fromJson(Map<String, Object?> json) {
    return CardValue(
      cardValueId: json[CardValuesFields.cardValueId] as int,
      valueName: json[CardValuesFields.valueName] != null
          ? json[CardValuesFields.valueName] as String
          : json[CardValuesFields.valueNameEn] as String,
      cardId: json[CardValuesFields.cardId] as int,
      upward: json[CardValuesFields.upward] != null
          ? json[CardValuesFields.upward] as String
          : json[CardValuesFields.upwardEn] as String,
      downward: json[CardValuesFields.downward] != null
          ? json[CardValuesFields.downward] as String
          : json[CardValuesFields.downwardEn] != null
              ? json[CardValuesFields.downwardEn] as String
              : '',
    );
  }

  /// Creates a copy of this card value with optional updated fields.
  ///
  /// Useful for immutability and state updates.
  CardValue copy({
    int? cardValueId,
    int? cardId,
    String? valueName,
    String? upward,
    String? downward,
  }) =>
      CardValue(
        cardValueId: cardValueId ?? this.cardValueId,
        valueName: valueName ?? this.valueName,
        cardId: cardId ?? this.cardId,
        upward: upward ?? this.upward,
        downward: downward ?? this.downward,
      );
}
