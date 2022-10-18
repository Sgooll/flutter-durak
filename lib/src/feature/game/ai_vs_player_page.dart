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
    aiMove();
  }

  aiBito() {
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
    print(" player 1 hand after take cards  = ${widget.player1.hand.length}");
    print("qty = ${Game.deck.length}");
    setState(() {
      if (widget.player1.grabbed) {
        playerMove = true;
        widget.player2.isAttack = true;
        widget.player2.isDefend = false;
        widget.player1.isAttack = false;
        widget.player1.isDefend = true;
      } else {
        playerMove = false;
        widget.player2.isAttack = false;
        widget.player2.isDefend = true;
        widget.player1.isAttack = true;
        widget.player1.isDefend = false;
      }
    });
    setState(() {
      Game.table.clear();
    });
    if (!widget.player1.grabbed) {
      aiMove();
    }
  }

  playerBito() {
    for (var card in Game.table.entries) {
      if (card.value == null && !widget.player2.grabbed) {
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
      if (widget.player2.grabbed) {
        playerMove = false;
        widget.player1.isAttack = true;
        widget.player1.isDefend = false;
        widget.player2.isAttack = false;
        widget.player2.isDefend = true;
      } else {
        playerMove = true;
        widget.player1.isAttack = false;
        widget.player1.isDefend = true;
        widget.player2.isAttack = true;
        widget.player2.isDefend = false;
      }
    });
    print(" player 2 hand after Defend  = ${widget.player2.hand.length}");
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
  }

  aiMove() {
    widget.player1.makeMove();
    print("Table = ${Game.table}");
    setState(() {
      playerMove = true;
    });
  }

  aiDef() {
    print(" player 1 hand  = ${widget.player1.hand.length}");
    widget.player1.defend();
    if (widget.player1.grabbed) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Беру!")));
      aiBito();
      return;
    }
    widget.player2.canToss = true;
    chosenCards.clear();
    playerMove = true;
    print(" player 1 hand after Defend  = ${widget.player1.hand.length}");

    print("Table = ${Game.table}");
    setState(() {});
  }

  bool playerMove = false;

  List<PlayingCard> chosenCards = [];

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
              SizedBox(
                height: 200,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.player1.hand.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          child: Container(
                        margin: EdgeInsets.only(left: 5),
                        width: 140,
                        height: 300,
                        decoration: BoxDecoration(
                            //color: Colors.red,
                            gradient: LinearGradient(colors: [
                              Colors.red,
                              Colors.indigo,
                            ]),
                            border: Border.all(color: Colors.white, width: 2)),
                      ));
                    }),
              ),
              /* if (widget.player1.isAttack && !playerMove)
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
                      if (widget.player1.grabbed) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Беру!")));
                        aiBito();
                        return;
                      }
                      widget.player2.canToss = true;
                      chosenCards.clear();
                      playerMove = true;
                      print(
                          " player 1 hand after Defend  = ${widget.player1.hand.length}");

                      print("Table = ${Game.table}");
                      setState(() {});
                    },
                    child: Text(
                      "Побиться",
                      style: AppTextTheme.button,
                    )),*/
              Divider(height: 20),
              SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var card in Game.table.entries)
                        Stack(
                          //alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              card.key.imagePath,
                            ),
                            if (card.value != null)
                              Positioned(
                                  top: 30,
                                  child: SizedBox(
                                      height: 100,
                                      child: Image.asset(
                                        card.value!.imagePath,
                                      )))
                          ],
                        )
                    ],
                  )),
              Center(
                child: Column(
                  children: [
                    Text(playerMove ? "Ваш ход" : "Ход соперника"),
                    if (chosenCards.isEmpty &&
                        playerMove &&
                        (Game.table.values.contains(null) ||
                            Game.table.isEmpty))
                      Text("Выберите карты, которыми будете ходить"),
                  ],
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.player2.isDefend && playerMove)
                      Button(
                          onPressed: Game.table.values.contains(null)
                              ? () async {
                                  widget.player2.grab();
                                  widget.player2.grabbed = true;
                                  playerBito();
                                  aiMove();
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
                        onPressed: chosenCards.isNotEmpty
                            ? () async {
                                if (widget.player2.isAttack) {
                                  if (widget.player2.canToss) {
                                    var result = widget.player2.toss(
                                        context: context,
                                        chosenCards: chosenCards);
                                    if (result != null) {
                                      return;
                                    }
                                    setState(() {
                                      chosenCards.clear();
                                      playerMove = false;
                                    });
                                    return;
                                  }
                                  final result = widget.player2
                                      .makeMove(cards: chosenCards);
                                  if (result == false) {
                                    return;
                                  }
                                  print("Table = ${Game.table}");
                                  setState(() {
                                    playerMove = false;
                                  });
                                  aiDef();
                                } else if (widget.player2.isDefend) {
                                  print(
                                      " player 2 hand  = ${widget.player2.hand.length}");
                                  final result = widget.player2
                                      .defend(chosenCards: chosenCards);
                                  if (result != null) {
                                    return;
                                  }
                                  widget.player1.canToss = true;
                                  widget.player1.toss(context: context);
                                  setState(() {});
                                }
                                setState(() {
                                  chosenCards.clear();
                                });
                              }
                            : null,
                        child: Text(
                          "Положить карты",
                          style: AppTextTheme.button,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    if (playerMove)
                      Button(
                          onPressed: Game.table.isNotEmpty &&
                                  !Game.table.values.contains(null)
                              ? () async {
                                  if (widget.player2.canToss) {
                                    aiBito();
                                    widget.player2.canToss = false;
                                  } else {
                                    playerBito();
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
                            margin: EdgeInsets.only(left: 5),
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
