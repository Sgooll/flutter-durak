import 'package:flutter/material.dart';
import 'package:flutter_durak/src/config/themes.dart';
import 'package:flutter_durak/src/core/AI/ai.dart';
import 'package:flutter_durak/src/data/cards/func.dart';
import 'package:flutter_durak/src/data/game/game.dart';
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
    widget.player1.initPlayer();
    widget.player2.initPlayer();
  }

  bool playerMove = false;

  List<PlayingCard> chosenCards = [];

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
              if (widget.player1.isAttack && !playerMove)
                Button(
                    onPressed: () {
                      widget.player1.makeMove();
                      print("Table = ${Game.table}");
                      setState(() {
                        playerMove = true;
                      });
                    },
                    child: Text(
                      "Сделать ход",
                      style: AppTextTheme.button,
                    )),
              if (widget.player1.isDefend && !playerMove)
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
                        if (Game.deck.isNotEmpty) {
                          while (widget.player2.hand.length < 6) {
                            widget.player2.takeCard();
                          }
                        }
                      }
                      print(
                          " player 1 hand after take cards  = ${widget.player1.hand.length}");
                      print("qty = ${Game.deck.length}");
                      setState(() {
                        playerMove = false;
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
              AnimatedSize(
                duration: Duration(seconds: 1),
                child: SizedBox(
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
              ),
              Center(
                child: Text(playerMove ? "Ваш ход" : "Ход соперника"),
              ),
              Divider(height: 20),
              /*if (widget.player2.isAttack && !playerDone)
                Button(
                    onPressed: () {},
                    child: Text(
                      "Сделать ход",
                      style: AppTextTheme.button,
                    )),
              if (widget.player2.isDefend && playerDone)
                Button(
                    onPressed: () async {},
                    child: Text(
                      "Побиться",
                      style: AppTextTheme.button,
                    )),*/
              if (playerMove)
                Button(
                    onPressed: () async {
                      if (widget.player2.isAttack) {
                        final result =
                            widget.player2.makeMove(cards: chosenCards);
                        if (result == false) {
                          return;
                        }
                        print("Table = ${Game.table}");
                        setState(() {
                          playerMove = false;
                        });
                      } else if (widget.player2.isDefend) {
                        print(
                            " player 2 hand  = ${widget.player2.hand.length}");
                        final result =
                            widget.player2.defend(chosenCards: chosenCards);
                        if (result != null) {
                          return;
                        }
                      }
                      setState(() {
                        chosenCards.clear();
                      });
                    },
                    child: Text(
                      "Положить карты",
                      style: AppTextTheme.button,
                    )),
              if (widget.player2.isDefend && playerMove)
                Button(
                    onPressed: () async {
                      widget.player2.grab();
                      widget.player2.grabbed = true;
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
                        playerMove = false;
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
                      //await Future.delayed(Duration(seconds: 1));

                      setState(() {
                        chosenCards.clear();
                        Game.table.clear();
                      });
                    },
                    child: Text(
                      "Взять",
                      style: AppTextTheme.button,
                    )),
              if (widget.player2.isDefend && playerMove)
                Button(
                    onPressed: () async {
                      for (var card in Game.table.entries) {
                        if (card.value == null) {
                          return;
                        }
                      }
                      if (Game.deck.isNotEmpty) {
                        while (widget.player2.hand.length < 6) {
                          widget.player2.takeCard();
                        }
                        while (widget.player1.hand.length < 6) {
                          widget.player1.takeCard();
                        }
                      }
                      setState(() {
                        //playerMove = true;
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
                      //await Future.delayed(Duration(seconds: 1));

                      setState(() {
                        Game.table.clear();
                      });
                    },
                    child: Text(
                      "Бито",
                      style: AppTextTheme.button,
                    )),
              SizedBox(
                height: 200,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.player2.hand.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: playerMove
                              ? () async {
                                  if (chosenCards
                                      .contains(widget.player2.hand[index])) {
                                    chosenCards
                                        .remove(widget.player2.hand[index]);
                                  } else {
                                    chosenCards.add(widget.player2.hand[index]);
                                  }
                                  //print(chosenCards.length);
                                  /* if (widget.player2.isAttack) {
                              if (Game.table.containsKey(
                                      widget.player2.hand[index]) ||
                                  Game.table.isEmpty) {
                                widget.player2.makeMove(
                                    cards: [widget.player2.hand[index]]);
                                print("Table = ${Game.table}");
                                setState(() {
                                  playerDone = true;
                                });
                              }
                            } else if (widget.player2.isDefend) {
                              print(
                                  " player 2 hand  = ${widget.player2.hand.length}");
                              final result = widget.player2.defend(
                                  chosenCards: [widget.player2.hand[index]]);
                              if (result != null) {
                                return;
                              }
                            }*/
                                  setState(() {});
                                  /*print("qty = ${Game.deck.length}");
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
                            });*/
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: chosenCards
                                        .contains(widget.player2.hand[index])
                                    ? Border.all(
                                        color: Colors.yellowAccent, width: 4)
                                    : null),
                            child: Image.asset(
                                widget.player2.hand[index].imagePath),
                          ));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
