import 'package:flutter/material.dart';
import 'package:flutter_durak/src/config/themes.dart';
import 'package:flutter_durak/src/core/AI/ai.dart';
import 'package:flutter_durak/src/data/cards/card_func.dart';
import 'package:flutter_durak/src/data/cards/game_func.dart';
import 'package:flutter_durak/src/data/game/game.dart';
import 'package:flutter_durak/src/feature/game/widgets/enemy_cards_widget.dart';
import 'package:flutter_durak/src/feature/game/widgets/player_actions_widget.dart';
import 'package:flutter_durak/src/feature/game/widgets/table_widget.dart';
import 'package:flutter_durak/src/feature/game/widgets/your_cards_widget.dart';
import 'package:flutter_durak/src/feature/widgets/button.dart';

import '../../data/cards/card.dart';

class AiVsPlayerPage extends StatefulWidget {
  AiVsPlayerPage({Key? key}) : super(key: key);
  final Player player1 = Player(isAttack: true, isDefend: false, ai: true);

  final Player player2 = Player(isAttack: false, isDefend: true, ai: false);

  @override
  State<AiVsPlayerPage> createState() => _AiVsPlayerPageState();
}

class _AiVsPlayerPageState extends State<AiVsPlayerPage> {
  initState() {
    widget.player1.addListener(() {
      setState(() {});
    });
    widget.player2.addListener(() {
      setState(() {});
    });
    widget.player1.initPlayer();
    widget.player2.initPlayer();
    GameFunc.aiMove(player1: widget.player1, player2: widget.player2);
  }

  @override
  Widget build(BuildContext context) {
    if (Game.deck.isEmpty && widget.player1.hand.isEmpty) {
      Future.delayed(Duration(milliseconds: 100), () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Вы проиграли! :(")));
      });
    }
    if (Game.deck.isEmpty && widget.player2.hand.isEmpty) {
      Future.delayed(Duration(milliseconds: 100), () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Вы выиграли! :)")));
      });
    }
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 80,
                      child: Image.asset(Game.trump!.imagePath)),
                  Text("Карт в колоде: ${Game.deck.length}"),
                ],
              ),
              EnemyCardWidget(player: widget.player1),
              Divider(height: 20),
              TableWidget(),
              Center(
                child: Column(
                  children: [
                    Text(widget.player2.playerMove
                        ? "Ваш ход"
                        : "Ход соперника"),
                    if (widget.player2.chosenCards.isEmpty &&
                        widget.player2.playerMove &&
                        (Game.table.values.contains(null) ||
                            Game.table.isEmpty))
                      Text("Выберите карты, которыми будете ходить"),
                  ],
                ),
              ),
              Divider(height: 20),
              PlayerActionsWidget(
                  player1: widget.player1, player2: widget.player2),
              YourCardsWidget(player: widget.player2),
            ],
          ),
        ),
      ),
    );
  }
}
