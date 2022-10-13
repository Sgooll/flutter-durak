import 'package:flutter_durak/src/data/enums.dart';
import 'package:flutter_durak/src/data/game/game.dart';

import '../../data/cards/card.dart';

class Player {
  List<PlayingCard> hand = [];
  bool isAttack;
  bool isDefend;
  bool ai;

  bool grabbed = false;

  Player({
    required this.isAttack,
    required this.isDefend,
    required this.ai,
  });

  takeCard() {
    hand.add(Game.deck.last);
    Game.deck.removeLast();
  }

  initPlayer() {
    for (int i = 0; i < 6; i++) {
      takeCard();
    }
  }

  bool? makeMove({List<PlayingCard>? cards}) {
    List<PlayingCard> tmp = [];
    if (ai) {
      hand.sort((a, b) => a.rankValue.compareTo(b.rankValue));
      tmp = hand
          .where((element) => element.rankValue == hand.first.rankValue)
          .toList();
      if (Game.deck.length >= 10) {
        tmp.removeWhere((element) => element.suit == Game.trump!.suit);
        print("TMP = ${tmp}");
      }
    } else {
      if (cards!.isEmpty) {
        return false;
      }
      if (cards!.length > 1) {
        int count = 0;
        for (int i = 0; i < cards.length; i++) {
          if (i != cards.length - 1) {
            if (cards[i].rank == cards[i + 1].rank) {
              count++;
            }
          }
        }
        print(count);
        print(cards);
        if (count == cards.length - 1) {
          tmp.addAll(cards);
        } else {
          print("You can't make move with this cards");
          return false;
        }
      } else {
        tmp.addAll(cards);
      }
    }

    for (var card in tmp) {
      Game.table.addAll({card: null});
    }
    if (ai) {
      hand.removeWhere((element) => element.rankValue == hand.first.rankValue);
    } else {
      for (var handCard in cards!) {
        hand.remove(handCard);
      }
    }
  }

  bool? defend({List<PlayingCard>? chosenCards}) {
    if (ai) {
      for (var card in Game.table.entries) {
        var approachCards = hand
            .where((element) =>
                element.rankValue > card.key.rankValue &&
                (element.suit == card.key.suit))
            .toList();
        if (approachCards.isEmpty) {
          approachCards = hand
              .where((element) => element.suit == Game.trump!.suit)
              .toList();
        }
        approachCards.sort((a, b) => a.rankValue.compareTo(b.rankValue));
        if (approachCards.isNotEmpty) {
          Game.table[card.key] = approachCards.first;
          hand.removeWhere((element) => element == approachCards.first);
        } else {
          grab();
          grabbed = true;
          print("NEED TO GRAB BRO");
          return false;
        }
        grabbed = false;
      }
    } else {
      for (var card in Game.table.entries) {
        print("card = ${card}");
        for (int handCard = 0; handCard < chosenCards!.length; handCard++) {
          print("handCard = ${handCard}");
          if (chosenCards[handCard].rankValue > card.key.rankValue &&
              chosenCards[handCard].suit == card.key.suit) {
            Game.table[card.key] = chosenCards[handCard];
            hand.removeWhere((element) => element == chosenCards[handCard]);
            grabbed = false;
            print("1111111");
            break;
          } else if (chosenCards[handCard].rankValue > card.key.rankValue &&
              chosenCards[handCard].suit == Game.trump!.suit) {
            Game.table[card.key] = chosenCards[handCard];
            hand.removeWhere((element) => element == chosenCards[handCard]);
            grabbed = false;
            print("22222222");
            break;
          } else {
            print("Choose another cards!!!");
            if (handCard == chosenCards.length) {
              return false;
            }
            continue;
          }
        }
      }
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
