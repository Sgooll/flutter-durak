import 'package:flutter/material.dart';

import '../enums.dart';
import 'card.dart';

class CardFunc {
  static List<PlayingCard> generateDeck() {
    List<PlayingCard> deck = [];
    for (int suit = 0; suit < Suit.values.length; suit++) {
      for (int rank = 0; rank < Rank.values.length; rank++) {
        deck.add(
          PlayingCard(
              rankValue: getRankValue(Rank.values[rank]),
              suit: Suit.values[suit],
              imagePath:
                  'assets/cards/${Rank.values[rank].name}_of_${Suit.values[suit].name}.png',
              rank: Rank.values[rank]),
        );
      }
    }
    deck.shuffle();
    return deck;
  }

  static int getRankValue(Rank rank) {
    switch (rank) {
      case Rank.two:
        return 2;
      case Rank.three:
        return 3;
      case Rank.four:
        return 4;
      case Rank.five:
        return 5;
      case Rank.six:
        return 6;
      case Rank.seven:
        return 7;
      case Rank.eight:
        return 8;
      case Rank.nine:
        return 9;
      case Rank.ten:
        return 10;
      case Rank.jack:
        return 11;
      case Rank.queen:
        return 12;
      case Rank.king:
        return 13;
      case Rank.ace:
        return 14;
    }
  }
}
