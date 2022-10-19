import 'package:flutter/material.dart';
import 'package:flutter_durak/src/data/cards/game_func.dart';

import '../../../config/themes.dart';
import '../../../core/AI/ai.dart';
import '../../../data/game/game.dart';
import '../../widgets/button.dart';

class PlayerActionsWidget extends StatefulWidget {
  const PlayerActionsWidget(
      {Key? key, required this.player1, required this.player2})
      : super(key: key);

  final Player player1;
  final Player player2;

  @override
  State<PlayerActionsWidget> createState() => _PlayerActionsWidgetState();
}

class _PlayerActionsWidgetState extends State<PlayerActionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.player2.playerMove)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.player2.isDefend && widget.player2.playerMove)
                Button(
                    onPressed: Game.table.values.contains(null)
                        ? () async {
                            widget.player2.grab();
                            widget.player2.grabbed = true;
                            GameFunc.playerBito(
                                player1: widget.player1,
                                player2: widget.player2);
                            GameFunc.aiMove(
                                player1: widget.player1,
                                player2: widget.player2);
                          }
                        : null,
                    child: Text(
                      "Взять",
                      style: AppTextTheme.button,
                    )),
              SizedBox(
                width: 10,
              ),
              Button(
                  onPressed: widget.player2.chosenCards.isNotEmpty &&
                          (Game.table.values.contains(null) ||
                              widget.player2.canToss ||
                              Game.table.isEmpty)
                      ? () async {
                          if (widget.player2.isAttack) {
                            if (widget.player2.canToss) {
                              var result = widget.player2.toss(
                                  context: context,
                                  chosenCards: widget.player2.chosenCards);
                              if (result != null) {
                                return;
                              }
                              widget.player2.clearChosenCard();
                              widget.player2.playerMove = false;
                              GameFunc.aiDef(context,
                                  player1: widget.player1,
                                  player2: widget.player2);
                              return;
                            }
                            final result = widget.player2
                                .makeMove(cards: widget.player2.chosenCards);
                            if (result == false) {
                              return;
                            }
                            print("Table = ${Game.table}");
                            widget.player2.playerMove = false;
                            GameFunc.aiDef(context,
                                player1: widget.player1,
                                player2: widget.player2);
                          } else if (widget.player2.isDefend) {
                            print(
                                " player 2 hand  = ${widget.player2.hand.length}");
                            final result = widget.player2.defend(
                                chosenCards: widget.player2.chosenCards);
                            if (result != null) {
                              print("CAN TOSS");
                              return;
                            }
                            widget.player1.canToss = true;
                            widget.player1.toss(context: context);
                          }
                          widget.player2.clearChosenCard();
                        }
                      : null,
                  child: Text(
                    "Положить карты",
                    style: AppTextTheme.button,
                  )),
              SizedBox(
                width: 10,
              ),
              if (widget.player2.playerMove)
                Button(
                    onPressed: Game.table.isNotEmpty &&
                            !Game.table.values.contains(null)
                        ? () async {
                            if (widget.player2.canToss) {
                              GameFunc.aiBito(
                                  player1: widget.player1,
                                  player2: widget.player2);
                              widget.player2.canToss = false;
                            } else {
                              GameFunc.playerBito(
                                  player1: widget.player1,
                                  player2: widget.player2);
                              widget.player1.canToss = false;
                            }
                          }
                        : null,
                    child: Text(
                      "Бито",
                      style: AppTextTheme.button,
                    )),
            ],
          ),
      ],
    );
  }
}
