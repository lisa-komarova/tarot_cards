String tableCardValues = 'CardValue';

class CardValuesFields {
  static final List<String> values = [
    cardValueId,
    valueName,
    cardId,
    upward,
    downward,
  ];
  static final List<String> valuesEn = [
    cardValueId,
    valueNameEn,
    cardId,
    upwardEn,
    downwardEn,
  ];

  static const cardValueId = 'cardValueId';
  static const valueName = 'valueName';
  static const valueNameEn = 'valueNameEn';
  static const cardId = 'cardID';
  static const upward = 'upward';
  static const downward = 'downward';
  static const upwardEn = 'upwardEn';
  static const downwardEn = 'downwardEn';
}

///card values model, represents the meaning of a card in different situations
class CardValue {
  final int cardValueId;
  final String valueName;
  final int cardId;
  final String upward;
  final String downward;

  const CardValue(
      {required this.cardValueId,
      required this.valueName,
      required this.cardId,
      required this.upward,
      required this.downward});
  Map<String, Object?> toJson() => {
        CardValuesFields.cardValueId: cardValueId,
        CardValuesFields.cardId: cardId,
        CardValuesFields.valueName: valueName,
        CardValuesFields.upward: upward,
        CardValuesFields.downward: downward
      };
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

  CardValue copy(
          {int? cardValueId,
          int? cardId,
          String? valueName,
          String? upward,
          String? downward}) =>
      CardValue(
          cardValueId: cardValueId ?? this.cardValueId,
          valueName: valueName ?? this.valueName,
          cardId: cardId ?? this.cardId,
          upward: upward ?? this.upward,
          downward: downward ?? this.downward);
}
