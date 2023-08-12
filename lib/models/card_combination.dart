String tableCardCombination = 'CardCombination';

class CardCombinationFields {
  static final List<String> values = [
    cardCombinationId,
    firstCardId,
    secondCardId,
    value,
  ];

  static const cardCombinationId = 'cardCombinationId';
  static const firstCardId = 'firstCardId';
  static const secondCardId = 'secondCardId';
  static const value = 'value';
}
///taro card combination model, represents the meaning of the combination of two cards
class CardCombintaion {
  int cardCombinationId;
  int firstCardId;
  int secondCardId;
  String value;
  CardCombintaion({
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
  static CardCombintaion fromJson(Map<String, Object?> json) {
    return CardCombintaion(
        cardCombinationId: json[CardCombinationFields.cardCombinationId] as int,
        firstCardId: json[CardCombinationFields.firstCardId] as int,
        secondCardId: json[CardCombinationFields.secondCardId] as int,
        value: json[CardCombinationFields.value] as String,);
  }

  CardCombintaion copy(
          {int? cardCombinationId,
          int? firstCardId,
          int? secondCardId,
          String? value,}) =>
      CardCombintaion(
          cardCombinationId: cardCombinationId ?? this.cardCombinationId,
          firstCardId: firstCardId ?? this.firstCardId,
          secondCardId: secondCardId ?? this.secondCardId,
          value: value ?? this.value);
}
