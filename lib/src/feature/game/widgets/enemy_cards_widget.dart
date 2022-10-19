import 'package:flutter/material.dart';

import '../../../core/AI/ai.dart';

class EnemyCardWidget extends StatefulWidget {
  const EnemyCardWidget({Key? key, required this.player}) : super(key: key);

  final Player player;

  @override
  State<EnemyCardWidget> createState() => _EnemyCardWidgetState();
}

class _EnemyCardWidgetState extends State<EnemyCardWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.player.hand.length,
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
    );
  }
}
