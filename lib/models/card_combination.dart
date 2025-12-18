/// Name of the database table that stores meanings of card combinations.
String tableCardCombination = 'CardCombination';

/// Contains column names used in the CardCombination table.
///
/// Provides lists of fields for general and English-only queries.
class CardCombinationFields {
  /// All available table columns.
  static final List<String> values = [
    cardCombinationId,
    firstCardId,
    secondCardId,
    value,
  ];

  /// Subset of columns used for English localization.
  static final List<String> valuesEn = [
    cardCombinationId,
    firstCardId,
    secondCardId,
    valueEn,
  ];

  /// Unique identifier of the card combination record.
  static const cardCombinationId = 'cardCombinationId';

  /// ID of the first card in the combination.
  static const firstCardId = 'firstCardId';

  /// ID of the second card in the combination.
  static const secondCardId = 'secondCardId';

  /// Meaning of the card combination.
  static const value = 'value';

  /// Meaning of the card combination in English.
  static const valueEn = 'valueEn';
}

/// Model representing the meaning of a combination of two tarot cards.
///
/// Each combination can have a unique interpretation based on the two cards involved.
class CardCombination {
  /// Unique identifier of this card combination.
  int cardCombinationId;

  /// ID of the first card in the combination.
  int firstCardId;

  /// ID of the second card in the combination.
  int secondCardId;

  /// Meaning/interpretation of this card combination.
  String value;

  CardCombination({
    required this.cardCombinationId,
    required this.firstCardId,
    required this.secondCardId,
    required this.value,
  });

  /// Converts this card combination into a JSON-compatible map.
  ///
  /// Useful for database storage or serialization.
  Map<String, Object?> toJson() => {
        CardCombinationFields.cardCombinationId: cardCombinationId,
        CardCombinationFields.firstCardId: firstCardId,
        CardCombinationFields.secondCardId: secondCardId,
        CardCombinationFields.value: value,
      };

  /// Creates a [CardCombination] instance from a JSON map.
  ///
  /// Uses English fallback if the localized text is not available.
  static CardCombination fromJson(Map<String, Object?> json) {
    return CardCombination(
      cardCombinationId: json[CardCombinationFields.cardCombinationId] as int,
      firstCardId: json[CardCombinationFields.firstCardId] as int,
      secondCardId: json[CardCombinationFields.secondCardId] as int,
      value: json[CardCombinationFields.value] != null
          ? json[CardCombinationFields.value] as String
          : json[CardCombinationFields.valueEn] as String,
    );
  }

  /// Creates a copy of this card combination with optional updated fields.
  ///
  /// Useful for immutability and state updates.
  CardCombination copy({
    int? cardCombinationId,
    int? firstCardId,
    int? secondCardId,
    String? value,
  }) =>
      CardCombination(
        cardCombinationId: cardCombinationId ?? this.cardCombinationId,
        firstCardId: firstCardId ?? this.firstCardId,
        secondCardId: secondCardId ?? this.secondCardId,
        value: value ?? this.value,
      );
}
