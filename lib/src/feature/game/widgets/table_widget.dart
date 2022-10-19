import 'package:flutter/cupertino.dart';

import '../../../data/game/game.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({Key? key}) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
        ));
  }
}
