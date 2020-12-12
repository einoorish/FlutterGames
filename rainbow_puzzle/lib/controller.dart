import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rainbow_puzzle/piece.dart';
import 'package:rainbow_puzzle/score.dart';
import 'package:rainbow_puzzle/start_button.dart';

enum Direction {UP, DOWN, LEFT, RIGHT, NONE}

class Controller {

  static bool inGame = false;

  static ScoreModel scoreModel = ScoreModel();
  static ButtonModel buttonModel = ButtonModel();

  static Random random = Random();

  static List<GamePiece> _pieces = [];
  static Map<Point, GamePiece> index = {};

  static get pieces => _pieces;

  static Direction lastDirection = Direction.RIGHT;

  //Since the Controller class has only static properties and doesn’t require an instance, it uses streams to notify listeners manually rather than requiring an instance of ChangeNotifier.
  //The broadcast property provides an implementation of Stream and StreamController to broadcast an event when a turn is complete.
  static StreamController broadcast = StreamController.broadcast();
  static StreamSubscription listen(Function handler) => broadcast.stream.listen(handler);

  static dispose() => broadcast.close();

  static void start() {
    inGame = true;
    buttonModel.text = "r e s t a r t";
    scoreModel.value = 0;
    _pieces = [];
    index = {};
    on(Offset(1,0));
  }

  static void gameOver() {
    inGame = false;
    buttonModel.text = "s t a r t";
    scoreModel.value = 0;
    _pieces = [];
    index = {};

    showToast(
      "GAME OVER",
      duration: Duration(seconds: 2),
      position: ToastPosition.center,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 13.0,
      textStyle: TextStyle(fontSize: 18.0),
    );
  }


  static void on(Offset offset){

    lastDirection = parse(offset);
    process(lastDirection);

    broadcast.add(null);
    if(_pieces.length > 48) gameOver(); //no place for new point => Game over

    //Сhoose unoccupied place for new point
    Point p = Point(random.nextInt(7), random.nextInt(7));
    while (index.containsKey(p))
      p = Point(random.nextInt(7), random.nextInt(7));

    addPiece(GamePiece(model: GamePieceModel(currPosition: p, value: 0)));
  }

  static Direction parse(Offset offset){

    if(offset.dx < 0 && offset.dx.abs() > offset.dy.abs()) return Direction.LEFT;
    if(offset.dx > 0 && offset.dx.abs() > offset.dy.abs()) return Direction.RIGHT;
    if(offset.dy < 0 && offset.dy.abs() > offset.dx.abs()) return Direction.UP;
    if(offset.dy > 0 && offset.dy.abs() > offset.dx.abs()) return Direction.DOWN;
    return Direction.NONE;
  }

  static void process(Direction direction) {

    switch (direction) {

      case (Direction.UP): return scan(0, 7, 1, Axis.vertical);
      case (Direction.DOWN): return scan(6, -1, -1, Axis.vertical);
      case (Direction.LEFT): return scan(0, 7, 1, Axis.horizontal);
      case (Direction.RIGHT): return scan(6, -1, -1, Axis.horizontal);

      default: break;
    }
  }

  static scan(int start, int end, int shift, Axis axis) {
  //Evaluate the board in the opposite direction of the swipe so the furthest items along the target vector will be handled first
    for (int i = start; i != end; i += shift)
      for (int j = 0; j != 7; j++) {
        Point p = axis == Axis.vertical ? Point(j, i) : Point(i, j);
        if (index.containsKey(p))
          check(start, shift, axis, index[p]);
      }

  }

  static void check(int start, int shift, Axis axis, GamePiece piece) {
    //Merge pieces as necessary and clear a path across the board for the remaining pieces under evaluation.

    int target = (axis == Axis.vertical) ? piece.position.y : piece.position.x;

    for (var n = target - shift; n != start - shift; n -= shift) {

      Point lookup = (axis == Axis.vertical) ? Point(piece.position.x, n) : Point(n, piece.position.y);

      if (!index.containsKey(lookup))
        target -= shift;
      else if (index[lookup].value == piece.value)
        return merge(piece, index[lookup]);
      else break;
    }

    Point destination = (axis == Axis.vertical) ? Point(piece.position.x, target) : Point(target, piece.position.y);

    if (destination != piece.position)
      relocate(piece, destination);
  }

  static void merge(GamePiece source, GamePiece target) {
    // Merge operations are handled by first checking whether the pieces being merged are at the highest possible value(purple),
    // if so they are both removed and a bonus score is awarded,
    // otherwise the target piece is removed and the incoming piece is promoted and moved to the target location.

    if (source.value == 6) {

      index.remove(source.position);
      index.remove(target.position);
      _pieces.remove(source);
      _pieces.remove(target);
      scoreModel.value += source.model.value * 100;

    } else {
      source.model.value += 1;
      index.remove(target.position);
      _pieces.remove(target);
      relocate(source, target.position);
      scoreModel.value += source.model.value * 10;
    }
  }

  static void relocate(GamePiece piece, Point destination) {
    index.remove(piece.position);
    piece.move(destination);
    index[piece.position] = piece;
  }

  static addPiece(GamePiece piece){
    _pieces.add(piece);
    index[piece.position] = piece;
  }

  static removePiece(GamePiece piece){
    _pieces.remove(piece);
    index[piece.position] = null;
  }

}