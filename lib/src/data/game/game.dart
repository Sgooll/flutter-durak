import 'package:flutter_durak/src/data/cards/card_func.dart';

import '../cards/card.dart';
import '../enums.dart';

class Game {
  static List<PlayingCard> deck = [];
  static PlayingCard? trump;
  static Map<PlayingCard, PlayingCard?> table = {};

  static initGame() {
    deck = CardFunc.generateDeck();
    trump = deck.first;
    for (var card in deck) {
      if (card.suit == trump!.suit) {
        card.rankValue += 13;
      }
    }
  }
}
