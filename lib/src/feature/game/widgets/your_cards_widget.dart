import 'package:flutter/material.dart';

import '../../../core/AI/ai.dart';

class YourCardsWidget extends StatefulWidget {
  const YourCardsWidget({Key? key, required this.player}) : super(key: key);

  final Player player;

  @override
  State<YourCardsWidget> createState() => _YourCardsWidgetState();
}

class _YourCardsWidgetState extends State<YourCardsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.player.hand.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: widget.player.playerMove
                    ? () async {
                        if (widget.player.chosenCards
                            .contains(widget.player.hand[index])) {
                          widget.player.removeChosenCard(index);
                        } else {
                          widget.player.addChosenCard(index);
                        }
                      }
                    : null,
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: widget.player.chosenCards
                              .contains(widget.player.hand[index])
                          ? Border.all(color: Colors.yellowAccent, width: 4)
                          : null),
                  child: Image.asset(widget.player.hand[index].imagePath),
                ));
          }),
    );
  }
}
