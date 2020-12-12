import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_puzzle/controller.dart';
import 'package:rainbow_puzzle/piece.dart';

class GameBoard extends StatefulWidget{
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  StreamSubscription _eventsStream;
  Offset dragOffset = Offset.zero;

  List<GamePiece> pieces = [];

  void onTurn(dynamic data) => setState((){pieces = Controller.pieces;});

  //GestureDetector is used to capture input, which is averaged over the course of the entire pan event and submitted to the controller
  //when the swipe action is complete
  void onPanUpdate(DragUpdateDetails event){
    dragOffset = Offset((dragOffset.dx + event.delta.dx)/2, (dragOffset.dy + event.delta.dy)/2);
  }

  //then it is reset for the next incoming gesture. This de-bounces the input, making it easier for the controller to interpret the intended direction.
  void onPanEnd(DragEndDetails event){
    if(Controller.inGame)
      Controller.on(dragOffset);
    dragOffset = Offset.zero;
  }


  @override
  void initState() {
    super.initState();
    //Event listener is set up to receive update events from the controller to re-draw the UI
    _eventsStream = Controller.listen(onTurn);
  }


  @override
  void dispose() {
    super.dispose();
    _eventsStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double root = size.width;

    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.circular(24)
            ),
            width: root,
            height: root,
            child: Container(
              child: Stack(
                children: pieces,
              ),
            )
          ),
    );

  }

}