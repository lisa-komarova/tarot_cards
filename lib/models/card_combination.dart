String tableCardCombination = 'CardCombination';

class CardCombinationFields {
  static final List<String> values = [
    cardCombinationId,
    firstCardId,
    secondCardId,
    value,
  ];
  static final List<String> valuesEn = [
    cardCombinationId,
    firstCardId,
    secondCardId,
    valueEn,
  ];

  static const cardCombinationId = 'cardCombinationId';
  static const firstCardId = 'firstCardId';
  static const secondCardId = 'secondCardId';
  static const value = 'value';
  static const valueEn = 'valueEn';
}

///tarot card combination model, represents the meaning of the combination of two cards
class CardCombination {
  int cardCombinationId;
  int firstCardId;
  int secondCardId;
  String value;

  CardCombination({
    required this.cardCombinationId,
    required this.firstCardId,
    required this.secondCardId,
    required this.value,
  });
  Map<String, Object?> toJson() => {
        CardCombinationFields.cardCombinationId: cardCombinationId,
        CardCombinationFields.firstCardId: firstCardId,
        CardCombinationFields.secondCardId: secondCardId,
        CardCombinationFields.value: value,
      };

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
          value: value ?? this.value);
}
