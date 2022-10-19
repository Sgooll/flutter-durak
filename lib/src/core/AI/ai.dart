import 'package:flutter/material.dart';
import 'package:flutter_durak/src/data/enums.dart';
import 'package:flutter_durak/src/data/game/game.dart';

import '../../data/cards/card.dart';

class Player extends ChangeNotifier {
  List<PlayingCard> hand = [];
  bool isAttack;
  bool isDefend;
  bool ai;
  bool _canToss = false;

  bool get canToss => _canToss;

  set canToss(bool value) {
    _canToss = value;
    notifyListeners();
  }

  bool grabbed = false;

  final List<PlayingCard> _chosenCards = [];

  List<PlayingCard> get chosenCards => _chosenCards;

  clearChosenCard() {
    chosenCards.clear();
    notifyListeners();
  }

  removeChosenCard(int index) {
    chosenCards.remove(hand[index]);
    notifyListeners();
  }

  addChosenCard(int index) {
    chosenCards.add(hand[index]);
    notifyListeners();
  }

  bool _playerMove = false;

  Player(
      {required this.isAttack,
      required this.isDefend,
      required this.ai,
      bool? playerMove})
      : _playerMove = playerMove ?? false;

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
        var trumpList =
            hand.where((element) => element.suit == Game.trump!.suit);
        if (trumpList.length != hand.length) {
          tmp.removeWhere((element) => element.suit == Game.trump!.suit);
        }
        print("TMP = ${tmp}");
      }
    } else {
      if (cards!.isEmpty) {
        return false;
      }
      if (cards.length > 1) {
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
                (element.suit == card.key.suit ||
                    element.suit == Game.trump!.suit))
            .toList();
        approachCards.sort((a, b) => a.rankValue.compareTo(b.rankValue));
        if (approachCards.isNotEmpty) {
          if (Game.table[card.key] == null) {
            Game.table[card.key] = approachCards.first;
            hand.removeWhere((element) => element == approachCards.first);
          }
        } else {
          grab();
          grabbed = true;
          print("NEED TO GRAB BRO");
          return false;
        }
        grabbed = false;
      }
    } else {
      int nullCount = 0;
      for (int i = 0; i < Game.table.length; i++) {
        if (Game.table.values.toList()[i] == null) {
          nullCount++;
        }
      }

      if (chosenCards!.length < nullCount) {
        if (Game.table.values.any((element) => element != null)) {
        } else {
          return false;
        }
      }
      for (var card in Game.table.entries) {
        for (int handCard = 0; handCard < chosenCards.length; handCard++) {
          if (chosenCards[handCard].rankValue > card.key.rankValue &&
              chosenCards[handCard].suit == card.key.suit) {
            Game.table[card.key] = chosenCards[handCard];
            hand.removeWhere((element) => element == chosenCards[handCard]);
            grabbed = false;
            break;
          } else if (chosenCards[handCard].rankValue > card.key.rankValue &&
              chosenCards[handCard].suit == Game.trump!.suit) {
            if (Game.table[card.key] == null) {
              Game.table[card.key] = chosenCards[handCard];
              hand.removeWhere((element) => element == chosenCards[handCard]);
              grabbed = false;
              break;
            }
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

  bool? toss({required BuildContext context, List<PlayingCard>? chosenCards}) {
    List<PlayingCard> approachCards = [];

    if (canToss) {
      if (ai) {
        for (var card in Game.table.entries) {
          print(hand
              .where((element) =>
                  element.rank == card.key.rank ||
                  element.rank == card.value?.rank)
              .toList());
          approachCards.addAll(hand
              .where((element) =>
                  element.rank == card.key.rank ||
                  element.rank == card.value?.rank)
              .toList());
        }
        if (approachCards.isNotEmpty) {
          for (var card in approachCards) {
            if (card.suit == Game.trump!.suit && Game.deck.length > 20) {
              continue;
            } else {
              Game.table.addEntries([MapEntry(card, null)]);
              hand.remove(card);
            }
          }
        } else {
          if (!Game.table.containsValue(null)) {
            print("BITO!!!");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Бито!")));
          }
          return false;
        }
      } else {
        for (MapEntry card in Game.table.entries) {
          for (int handCard = 0; handCard < chosenCards!.length; handCard++) {
            if (chosenCards[handCard].rank == card.key.rank ||
                chosenCards[handCard].rank == card.value?.rank) {
              approachCards.add(chosenCards[handCard]);
              hand.removeWhere((element) => element == chosenCards[handCard]);
              break;
            } else {
              if (handCard == chosenCards.length) {
                return null;
              }
              continue;
            }
          }
        }
        if (approachCards.isEmpty) {
          print("Choose another cards to toss!!!");
          return false;
        }
        for (var card in approachCards) {
          Game.table.addEntries([MapEntry(card, null)]);
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

  bool get playerMove => _playerMove;

  set playerMove(bool value) {
    _playerMove = value;
    notifyListeners();
  }
}
