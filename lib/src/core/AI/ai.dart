import 'package:flutter_durak/src/data/enums.dart';
import 'package:flutter_durak/src/data/game/game.dart';

import '../../data/cards/card.dart';

class Player {
  List<PlayingCard> hand = [];
  bool isAttack;
  bool isDefend;

  bool grabbed = false;

  Player({
    required this.isAttack,
    required this.isDefend,
  });

  takeCard() {
    hand.add(Game.deck.last);
    Game.deck.removeLast();
  }

  initPlayer() {
    /*for (int i = 0; i < 6; i++) {
      takeCard();
    }*/
    hand.add(PlayingCard(
        rank: Rank.two,
        suit: Suit.hearts,
        rankValue: 2,
        imagePath: 'assets/cards/two_of_hearts.png'));
    hand.add(PlayingCard(
        rank: Rank.two,
        suit: Suit.diamonds,
        rankValue: 2,
        imagePath: 'assets/cards/two_of_diamonds.png'));
  }

  makeMove() {
    hand.sort((a, b) => a.rankValue.compareTo(b.rankValue));

    List<PlayingCard> tmp = [];
    tmp = hand
        .where((element) => element.rankValue == hand.first.rankValue)
        .toList();
    if (Game.deck.length >= 10) {
      tmp.removeWhere((element) => element.suit == Game.trump!.suit);
      print("TMP = ${tmp}");
    }

    for (var card in tmp) {
      Game.table.addAll({card: null});
    }
    hand.removeWhere((element) => element.rankValue == hand.first.rankValue);
  }

  defend() {
    for (var card in Game.table.entries) {
      var approachCards = hand
          .where((element) =>
              element.rankValue > card.key.rankValue &&
              (element.suit == card.key.suit))
          .toList();
      if (approachCards.isEmpty) {
        approachCards =
            hand.where((element) => element.suit == Game.trump!.suit).toList();
      }
      approachCards.sort((a, b) => a.rankValue.compareTo(b.rankValue));
      if (approachCards.isNotEmpty) {
        Game.table[card.key] = approachCards.first;
        hand.removeWhere((element) => element == approachCards.first);
      } else {
        grab();
        grabbed = true;
        print("NEED TO GRAB BRO");
        return;
      }
      grabbed = false;
    }
  }

  grab() {
    for (var card in Game.table.entries) {
      hand.add(card.key);
      if (card.value != null) {
        hand.add(card.value!);
      }
    }
  }
}
