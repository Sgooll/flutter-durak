import 'package:flutter/material.dart';

import '../../core/AI/ai.dart';
import '../game/game.dart';

class GameFunc {
  static aiBito({required Player player1, required Player player2}) {
    if (Game.deck.isNotEmpty) {
      while (player1.hand.length < 6) {
        player1.takeCard();
      }
      if (Game.deck.isNotEmpty) {
        while (player2.hand.length < 6) {
          player2.takeCard();
        }
      }
    }
    print(" player 1 hand after take cards  = ${player1.hand.length}");
    print("qty = ${Game.deck.length}");
    if (player1.grabbed) {
      player2.playerMove = true;
      player2.isAttack = true;
      player2.isDefend = false;
      player1.isAttack = false;
      player1.isDefend = true;
    } else {
      player2.playerMove = false;
      player2.isAttack = false;
      player2.isDefend = true;
      player1.isAttack = true;
      player1.isDefend = false;
    }

    Game.table.clear();
    player1.canToss = false;
    player2.canToss = false;
    if (!player1.grabbed) {
      aiMove(player1: player1, player2: player2);
    }
  }

  static playerBito({required Player player1, required Player player2}) {
    for (var card in Game.table.entries) {
      if (card.value == null && !player2.grabbed) {
        return;
      }
    }
    if (Game.deck.isNotEmpty) {
      while (player2.hand.length < 6) {
        player2.takeCard();
      }
      while (player1.hand.length < 6) {
        player1.takeCard();
      }
    }

    if (player2.grabbed) {
      player2.playerMove = false;
      player1.isAttack = true;
      player1.isDefend = false;
      player2.isAttack = false;
      player2.isDefend = true;
    } else {
      player2.playerMove = true;
      player1.isAttack = false;
      player1.isDefend = true;
      player2.isAttack = true;
      player2.isDefend = false;
    }
    print(" player 2 hand after Defend  = ${player2.hand.length}");
    if (Game.deck.isNotEmpty) {
      while (player2.hand.length < 6) {
        player2.takeCard();
      }
      while (player1.hand.length < 6) {
        player1.takeCard();
      }
    }
    //await Future.delayed(Duration(seconds: 1));

    Game.table.clear();
    player1.canToss = false;
    player2.canToss = false;
  }

  static aiMove({required Player player1, required Player player2}) {
    player1.makeMove();
    print("Table = ${Game.table}");
    player2.playerMove = true;
  }

  static aiDef(context, {required Player player1, required Player player2}) {
    print(" player 1 hand  = ${player1.hand.length}");
    player1.defend();
    if (player1.grabbed) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Беру!")));
      aiBito(player1: player1, player2: player2);
      return;
    }
    player2.canToss = true;
    player2.chosenCards.clear();
    player2.playerMove = true;
    print(" player 1 hand after Defend  = ${player1.hand.length}");

    print("Table = ${Game.table}");
  }
}
