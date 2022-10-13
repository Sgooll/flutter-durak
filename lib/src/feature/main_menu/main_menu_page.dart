import 'package:flutter/material.dart';
import 'package:flutter_durak/src/config/themes.dart';
import 'package:flutter_durak/src/core/AI/ai.dart';
import 'package:flutter_durak/src/data/cards/func.dart';
import 'package:flutter_durak/src/data/game/game.dart';
import 'package:flutter_durak/src/feature/game/ai_vs_ai_page.dart';
import 'package:flutter_durak/src/feature/widgets/button.dart';

import '../game/ai_vs_player_page.dart';

class MainMenuPage extends StatefulWidget {
  MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  bool playerDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  onPressed: () {
                    Game.initGame();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return AiVsAiPage();
                    }));
                  },
                  child: Text(
                    "Бот против бота",
                    style: AppTextTheme.button,
                  )),
              SizedBox(
                height: 20,
              ),
              Button(
                  onPressed: () {
                    Game.initGame();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return AiVsPlayerPage();
                    }));
                  },
                  child: Text(
                    "Игрок против бота",
                    style: AppTextTheme.button,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
