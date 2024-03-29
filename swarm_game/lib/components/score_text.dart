import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swarm_game/game_controller.dart';

class ScoreText{
  final GameController gameController;
  TextPainter painter;
  Offset position;

  ScoreText(this.gameController){
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
    );
    position = Offset.zero;
  }

  void render(Canvas canvas){
    painter.paint(canvas, position);
  }

  void update(double t){
    // (painter.text ?? '') means if @painter is null then set it to ''
    if ((painter.text ?? '') != gameController.score.toString()) {
      painter.text = TextSpan(
        text: gameController.score.toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 70.0,
        ),
      );
      painter.layout();

      position = Offset(
        (gameController.screenSize.width / 2) - (painter.width / 2),
        (gameController.screenSize.height * 0.2) - (painter.height / 2),
      );
    }
  }

}