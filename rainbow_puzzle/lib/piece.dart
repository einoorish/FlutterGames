import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:rainbow_puzzle/controller.dart';

//GamePieceModel: manages data and notifies listeners when changed
class GamePieceModel extends ChangeNotifier{

  int value;
  Point currPosition, prevPosition;

  Direction get initialDirection => Controller.lastDirection;

  //When a game piece is created, an instance of GamePieceModel is passed in to store the position and value of the piece,
  //previous swipe direction is retrieved from the game controller to determine which side of the board the new game piece will slide in from.
  GamePieceModel({this.value, this.currPosition}){
    prevPosition = initialPoint(this.initialDirection);
  }

  Point initialPoint(Direction direction){
    switch(initialDirection){
      case Direction.UP: return Point(this.currPosition.x, 6);
      case Direction.DOWN: return Point(this.currPosition.x, 0);
      case Direction.LEFT: return Point(6, this.currPosition.y);
      case Direction.RIGHT: return Point(0, this.currPosition.y);
      case Direction.NONE: break;
    }
    return Point(0,0);
  }

  void move(Point to){
    this.prevPosition = currPosition;
    this.currPosition = to;
    notifyListeners();
  }
}

//GamePieceView: renders a circle that animates itself when moved
class GamePieceView extends AnimatedWidget {

  final GamePieceModel model;

  AnimationController get controller => listenable;

  final Animation<double> x, y;

  final List<Color> colors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple
  ];

  GamePieceView({Key key, this.model, controller})
      :
        x = Tween<double>(
            begin: model.prevPosition.x.toDouble(), end: model.currPosition.x.toDouble())
            .animate(CurvedAnimation(parent: controller,
            curve: Interval(0.0, 0.100, curve: Curves.ease))),
        y = Tween<double>(
            begin: model.prevPosition.y.toDouble(), end: model.currPosition.y.toDouble())
            .animate(CurvedAnimation(parent: controller,
            curve: Interval(0.0, 0.100, curve: Curves.ease))),

        super(key: key, listenable: controller);

  //Positioning of each piece within the parent Stack is accomplished within GamePieceView by using Align and FractionalOffset, to offset each piece by a factor of one-seventh the total board size on both the x and y axes.

  @override
  Widget build(BuildContext context) {
    model.prevPosition = model.currPosition;

    Size size = MediaQuery.of(context).size;
    double itemSize = size.width / 7;

    return Align(
        alignment: FractionalOffset(x.value / 6, y.value / 6),
        child: Container(
            constraints: BoxConstraints(
                maxHeight: itemSize,
                maxWidth: itemSize
            ),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: itemSize * 0.7,
                width: itemSize * 0.7,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: colors[model.value].withOpacity(0.6),
                    border: Border.all(color: colors[model.value].withOpacity(0.3), width: 2),
                    borderRadius: BorderRadius.circular(itemSize / 2)
                ),
              ),
            )
        )
    );
  }
}

//GamePiece: wraps GamePieceModel and GamePieceView in a widget
//Each GamePiece renders a GamePieceView widget straight through to the parent Stack on the game board.

class GamePiece extends StatefulWidget{

  final GamePieceModel model;

  int get value => model.value;
  Point get position => model.currPosition;
  void move(Point to) => model.move(to);

  GamePiece({Key key, @required this.model}):super(key: key);

  @override
  _GamePieceState createState() => _GamePieceState();

}

class _GamePieceState extends State<GamePiece> with TickerProviderStateMixin {

  AnimationController _controller;

  @override void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider.value(
        value: widget.model,
        child: Consumer<GamePieceModel>(
          builder: (context, model, child){
            try {
              _controller.reset();
              _controller.forward();
            }
            on TickerCanceled {}

            return GamePieceView(model : model, controller: _controller);
          }
        )
      );
  }

}
