const String tableTaroCards = 'TaroCards';

class TaroCardsFields {
  static final List<String> values = [
    cardId,
    cardName,
    category,
    upward,
    downward,
    imagePath
  ];

  static const String cardId = 'cardId';
  static const String cardName = 'cardName';
  static const String category = 'category';
  static const String upward = 'upward';
  static const String downward = 'downward';
  static const String imagePath = 'imagePath';
}

///tarot card model
class TaroCard {
  final int cardId;
  final String cardName;
  final String category;
  final String upward;
  final String downward;
  final String imagePath;

  const TaroCard(
      {required this.cardId,
      required this.cardName,
      required this.category,
      required this.upward,
      required this.downward,
      required this.imagePath});

  Map<String, Object?> toJson() => {
        TaroCardsFields.cardId: cardId,
        TaroCardsFields.cardName: cardName,
        TaroCardsFields.category: category,
        TaroCardsFields.upward: upward,
        TaroCardsFields.downward: downward,
        TaroCardsFields.imagePath: imagePath
      };

  static TaroCard fromJson(Map<String, Object?> json) => TaroCard(
      cardId: json[TaroCardsFields.cardId] as int,
      cardName: json[TaroCardsFields.cardName] as String,
      category: json[TaroCardsFields.category] as String,
      upward: json[TaroCardsFields.upward] as String,
      downward: json[TaroCardsFields.downward] as String,
      imagePath: json[TaroCardsFields.imagePath] as String);

  TaroCard copy(
          {int? id,
          String? cardName,
          String? category,
          String? upward,
          String? downward,
          String? imagePath}) =>
      TaroCard(
          cardId: id ?? cardId,
          cardName: cardName ?? this.cardName,
          category: category ?? this.category,
          upward: upward ?? this.upward,
          downward: downward ?? this.downward,
          imagePath: imagePath ?? this.imagePath);
}
