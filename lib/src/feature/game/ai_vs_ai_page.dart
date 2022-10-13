import 'package:flutter/material.dart';
import 'package:flutter_durak/src/config/themes.dart';
import 'package:flutter_durak/src/core/AI/ai.dart';
import 'package:flutter_durak/src/data/cards/func.dart';
import 'package:flutter_durak/src/data/game/game.dart';
import 'package:flutter_durak/src/feature/widgets/button.dart';

class AiVsAiPage extends StatefulWidget {
  AiVsAiPage({Key? key}) : super(key: key);

  final Player player1 = Player(isAttack: true, isDefend: false, ai: true);

  final Player player2 = Player(isAttack: false, isDefend: true, ai: true);

  @override
  State<AiVsAiPage> createState() => _AiVsAiPageState();
}

class _AiVsAiPageState extends State<AiVsAiPage> {
  initState() {
    widget.player1.initPlayer();
    widget.player2.initPlayer();
  }

  bool playerDone = false;

  @override
  Widget build(BuildContext context) {
    if (Game.deck.isEmpty && widget.player1.hand.isEmpty) {
      print("PLAYER 1 WINS");
    }
    if (Game.deck.isEmpty && widget.player2.hand.isEmpty) {
      print("PLAYER 2 WINS");
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
              SizedBox(
                height: 200,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.player1.hand.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          child: Image.asset(
                              widget.player1.hand[index].imagePath));
                    }),
              ),
              if (widget.player1.isAttack && !playerDone)
                Button(
                    onPressed: () {
                      widget.player1.makeMove();
                      print("Table = ${Game.table}");
                      setState(() {
                        playerDone = true;
                      });
                    },
                    child: Text(
                      "Сделать ход",
                      style: AppTextTheme.button,
                    )),
              if (widget.player1.isDefend && playerDone)
                Button(
                    onPressed: () async {
                      print(" player 1 hand  = ${widget.player1.hand.length}");
                      widget.player1.defend();
                      print(
                          " player 1 hand after Defend  = ${widget.player1.hand.length}");

                      print("Table = ${Game.table}");
                      if (Game.deck.isNotEmpty) {
                        while (widget.player1.hand.length < 6) {
                          widget.player1.takeCard();
                        }
                        while (widget.player2.hand.length < 6) {
                          widget.player2.takeCard();
                        }
                      }
                      print(
                          " player 1 hand after take cards  = ${widget.player1.hand.length}");
                      print("qty = ${Game.deck.length}");
                      setState(() {
                        playerDone = false;
                        if (widget.player1.grabbed) {
                          widget.player2.isAttack = true;
                          widget.player2.isDefend = false;
                          widget.player1.isAttack = false;
                          widget.player1.isDefend = true;
                        } else {
                          widget.player2.isAttack = false;
                          widget.player2.isDefend = true;
                          widget.player1.isAttack = true;
                          widget.player1.isDefend = false;
                        }
                      });
                      await Future.delayed(Duration(seconds: 1));

                      setState(() {
                        Game.table.clear();
                      });
                    },
                    child: Text(
                      "Побиться",
                      style: AppTextTheme.button,
                    )),
              Divider(height: 20),
              SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      for (var card in Game.table.entries)
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Image.asset(card.key.imagePath),
                            if (card.value != null)
                              Image.asset(card.value!.imagePath)
                          ],
                        )
                    ],
                  )),
              Divider(height: 20),
              if (widget.player2.isAttack && !playerDone)
                Button(
                    onPressed: () {
                      widget.player2.makeMove();
                      print("Table = ${Game.table}");
                      setState(() {
                        playerDone = true;
                      });
                    },
                    child: Text(
                      "Сделать ход",
                      style: AppTextTheme.button,
                    )),
              if (widget.player2.isDefend && playerDone)
                Button(
                    onPressed: () async {
                      print(" player 2 hand  = ${widget.player2.hand.length}");
                      widget.player2.defend();
                      print(
                          " player 2 hand after Defend  = ${widget.player2.hand.length}");
                      if (Game.deck.isNotEmpty) {
                        while (widget.player2.hand.length < 6) {
                          widget.player2.takeCard();
                        }
                        while (widget.player1.hand.length < 6) {
                          widget.player1.takeCard();
                        }
                      }
                      print("qty = ${Game.deck.length}");
                      print(
                          " player 2 hand after take cards  = ${widget.player2.hand.length}");
                      print("Table = ${Game.table}");
                      setState(() {
                        playerDone = false;
                        if (widget.player2.grabbed) {
                          widget.player1.isAttack = true;
                          widget.player1.isDefend = false;
                          widget.player2.isAttack = false;
                          widget.player2.isDefend = true;
                        } else {
                          widget.player1.isAttack = false;
                          widget.player1.isDefend = true;
                          widget.player2.isAttack = true;
                          widget.player2.isDefend = false;
                        }
                      });
                      await Future.delayed(Duration(seconds: 1));

                      setState(() {
                        Game.table.clear();
                      });
                    },
                    child: Text(
                      "Побиться",
                      style: AppTextTheme.button,
                    )),
              SizedBox(
                height: 200,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.player2.hand.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          child: Image.asset(
                              widget.player2.hand[index].imagePath));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
