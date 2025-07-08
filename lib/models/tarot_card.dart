const String tableTaroCards = 'TaroCards';

class TarotCardsFields {
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
  static final List<String> valuesEn = [
    cardId,
    cardNameEn,
    categoryEn,
    upwardEn,
    downwardEn,
    imagePath,
  ];

  static const String cardId = 'cardId';
  static const String cardName = 'cardName';
  static const String cardNameEn = 'cardNameEn';
  static const String category = 'category';
  static const String categoryEn = 'categoryEn';
  static const String upward = 'upward';
  static const String downward = 'downward';
  static const String upwardEn = 'upwardEn';
  static const String downwardEn = 'downwardEn';
  static const String imagePath = 'imagePath';
}

///tarot card model
class TarotCard {
  final int cardId;
  final String cardName;
  final String category;
  final String upward;
  final String downward;
  final String imagePath;

  const TarotCard(
      {required this.cardId,
      required this.cardName,
      required this.category,
      required this.upward,
      required this.downward,
      required this.imagePath});

  Map<String, Object?> toJson() => {
        TarotCardsFields.cardId: cardId,
        TarotCardsFields.cardName: cardName,
        TarotCardsFields.category: category,
        TarotCardsFields.upward: upward,
        TarotCardsFields.downward: downward,
        TarotCardsFields.imagePath: imagePath
      };

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
      imagePath: json[TarotCardsFields.imagePath] as String);

  TarotCard copy(
          {int? id,
          String? cardName,
          String? category,
          String? upward,
          String? downward,
          String? imagePath}) =>
      TarotCard(
          cardId: id ?? cardId,
          cardName: cardName ?? this.cardName,
          category: category ?? this.category,
          upward: upward ?? this.upward,
          downward: downward ?? this.downward,
          imagePath: imagePath ?? this.imagePath);
}
