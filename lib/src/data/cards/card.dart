import '../enums.dart';

class PlayingCard {
  Rank rank;
  Suit suit;
  int rankValue;
  String imagePath;

  PlayingCard({
    required this.rank,
    required this.suit,
    required this.rankValue,
    required this.imagePath,
  });

  @override
  String toString() {
    return 'PlayingCard{rank: $rank, suit: $suit, rankValue: $rankValue}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayingCard &&
          runtimeType == other.runtimeType &&
          rank == other.rank &&
          suit == other.suit &&
          rankValue == other.rankValue;

  @override
  int get hashCode => rank.hashCode ^ suit.hashCode ^ rankValue.hashCode;
}
