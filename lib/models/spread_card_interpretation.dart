/// Name of the database table that stores card interpretations for specific spreads.
const String tableSpreadCardInterpretations = 'SpreadCardInterpretations';

/// Contains column names used in the SpreadCardInterpretations table.
///
/// Provides lists of fields for general and English-only queries.
class SpreadCardInterpretationsFields {
  /// All available table columns.
  static final List<String> values = [
    id,
    spreadId,
    positionId,
    cardId,
    text,
  ];

  /// Subset of columns used for English localization.
  static final List<String> valuesEn = [
    id,
    spreadId,
    positionId,
    cardId,
    textEn,
  ];

  /// Unique identifier of the interpretation record.
  static const id = 'id';

  /// Foreign key linking to a spread.
  static const spreadId = 'spreadId';

  /// Position of the card within the spread.
  static const positionId = 'positionId';

  /// Foreign key linking to a tarot card.
  static const cardId = 'cardId';

  /// Interpretation text in the local language.
  static const text = 'text';

  /// Interpretation text in English.
  static const textEn = 'textEn';
}

/// Model representing the interpretation of a tarot card
/// for a specific spread and position.
class SpreadCardInterpretation {
  /// Unique identifier of the interpretation record.
  final int? id;

  /// Identifier of the spread this interpretation belongs to.
  final int spreadId;

  /// Position of the card within the spread.
  final String position;

  /// Identifier of the tarot card.
  final int cardId;

  /// Interpretation text of the card in the local language.
  final String text;

  const SpreadCardInterpretation({
    this.id,
    required this.spreadId,
    required this.position,
    required this.cardId,
    required this.text,
  });

  /// Converts this interpretation into a JSON-compatible map.
  ///
  /// Useful for database storage or serialization.
  Map<String, Object?> toJson() => {
        SpreadCardInterpretationsFields.id: id,
        SpreadCardInterpretationsFields.spreadId: spreadId,
        SpreadCardInterpretationsFields.positionId: position,
        SpreadCardInterpretationsFields.cardId: cardId,
        SpreadCardInterpretationsFields.text: text,
      };

  /// Creates a [SpreadCardInterpretation] instance from a JSON map.
  ///
  /// Uses English fallback if the localized text is not available.
  static SpreadCardInterpretation fromJson(Map<String, Object?> json) {
    return SpreadCardInterpretation(
      id: json[SpreadCardInterpretationsFields.id] as int? ?? 0,
      spreadId: json[SpreadCardInterpretationsFields.spreadId] as int? ?? 0,
      position:
          json[SpreadCardInterpretationsFields.positionId] as String? ?? "",
      cardId: json[SpreadCardInterpretationsFields.cardId] as int? ?? 0,
      text: json[SpreadCardInterpretationsFields.text] != null
          ? json[SpreadCardInterpretationsFields.text] as String? ?? ''
          : json[SpreadCardInterpretationsFields.textEn] as String? ?? '',
    );
  }

  /// Creates a copy of this interpretation with optional updated fields.
  ///
  /// Useful for immutability and state updates.
  SpreadCardInterpretation copy({
    int? id,
    int? spreadId,
    String? position,
    int? cardId,
    String? text,
  }) =>
      SpreadCardInterpretation(
        id: id ?? this.id,
        spreadId: spreadId ?? this.spreadId,
        position: position ?? this.position,
        cardId: cardId ?? this.cardId,
        text: text ?? this.text,
      );
}
