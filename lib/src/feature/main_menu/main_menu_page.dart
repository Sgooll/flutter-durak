import 'package:flutter/material.dart';
import 'package:flutter_durak/src/config/themes.dart';
import 'package:flutter_durak/src/core/AI/ai.dart';
import 'package:flutter_durak/src/data/cards/func.dart';
import 'package:flutter_durak/src/data/game/game.dart';
import 'package:flutter_durak/src/feature/widgets/button.dart';

class MainMenuPage extends StatefulWidget {
  MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final Player player1 = Player(isAttack: true, isDefend: false);

  final Player player2 = Player(isAttack: false, isDefend: true);

  bool playerDone = false;
  bool isStart = true;

  @override
  Widget build(BuildContext context) {
    if (Game.deck.isEmpty && player1.hand.isEmpty) {
      print("PLAYER 1 WINS");
    }
    if (Game.deck.isEmpty && player2.hand.isEmpty) {
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
                  if (!isStart)
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
                    itemCount: player1.hand.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          child: Image.asset(player1.hand[index].imagePath));
                    }),
              ),
              if (player1.isAttack && !playerDone)
                Button(
                    onPressed: () {
                      player1.makeMove();
                      print("Table = ${Game.table}");
                      setState(() {
                        playerDone = true;
                      });
                    },
                    child: Text(
                      "Сделать ход",
                      style: AppTextTheme.button,
                    )),
              if (player1.isDefend && playerDone)
                Button(
                    onPressed: () async {
                      print(" player 1 hand  = ${player1.hand.length}");
                      player1.defend();
                      print(
                          " player 1 hand after Defend  = ${player1.hand.length}");

                      print("Table = ${Game.table}");
                      if (Game.deck.isNotEmpty) {
                        while (player1.hand.length < 6) {
                          player1.takeCard();
                        }
                        while (player2.hand.length < 6) {
                          player2.takeCard();
                        }
                      }
                      print(
                          " player 1 hand after take cards  = ${player1.hand.length}");
                      print("qty = ${Game.deck.length}");
                      setState(() {
                        playerDone = false;
                        if (player1.grabbed) {
                          player2.isAttack = true;
                          player2.isDefend = false;
                          player1.isAttack = false;
                          player1.isDefend = true;
                        } else {
                          player2.isAttack = false;
                          player2.isDefend = true;
                          player1.isAttack = true;
                          player1.isDefend = false;
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
              isStart
                  ? Button(
                      onPressed: () {
                        Game.initGame();
                        player1.initPlayer();
                        player2.initPlayer();

                        print("Trump = ${Game.trump}");
                        print("qty = ${Game.deck.length}");
                        setState(() {
                          isStart = false;
                        });
                      },
                      child: Text(
                        "Начать игру",
                        style: AppTextTheme.button,
                      ))
                  : SizedBox(
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
              if (player2.isAttack && !playerDone)
                Button(
                    onPressed: () {
                      player2.makeMove();
                      print("Table = ${Game.table}");
                      setState(() {
                        playerDone = true;
                      });
                    },
                    child: Text(
                      "Сделать ход",
                      style: AppTextTheme.button,
                    )),
              if (player2.isDefend && playerDone)
                Button(
                    onPressed: () async {
                      print(" player 2 hand  = ${player2.hand.length}");
                      player2.defend();
                      print(
                          " player 2 hand after Defend  = ${player2.hand.length}");
                      if (Game.deck.isNotEmpty) {
                        while (player2.hand.length < 6) {
                          player2.takeCard();
                        }
                        while (player1.hand.length < 6) {
                          player1.takeCard();
                        }
                      }
                      print("qty = ${Game.deck.length}");
                      print(
                          " player 2 hand after take cards  = ${player2.hand.length}");
                      print("Table = ${Game.table}");
                      setState(() {
                        playerDone = false;
                        if (player2.grabbed) {
                          player1.isAttack = true;
                          player1.isDefend = false;
                          player2.isAttack = false;
                          player2.isDefend = true;
                        } else {
                          player1.isAttack = false;
                          player1.isDefend = true;
                          player2.isAttack = true;
                          player2.isDefend = false;
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
                    itemCount: player2.hand.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          child: Image.asset(player2.hand[index].imagePath));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
