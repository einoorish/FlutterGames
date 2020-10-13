import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pacman/ghost.dart';
import 'package:pacman/pixel.dart';
import 'package:pacman/path.dart';
import 'package:pacman/player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int rowsCount = 11;
  int squaresCount = rowsCount * 17;
  int playerPosition = rowsCount*15+1;
  int ghostPosition = rowsCount*2-2;
  bool mouthClosed = false;
  int score = 0;

  List<int> food = new List<int>();
  final List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    24,
    35,
    46,
    57,
    26,
    37,
    38,
    39,
    78,
    84,
    28,
    30,
    41,
    52,
    63,
    127,
    116,
    105,
    106,
    107,
    108,
    79,
    79,
    80,
    81,
    70,
    59,
    61,
    72,
    83,
    4,
    85,
    86,
    100,
    101,
    102,
    103,
    114,
    125,
    123,
    134,
    145,
    156,
    158,
    147,
    148,
    149,
    160,
    129,
    140,
    151,
    162,
  ];

  String direction = "right";

  initFood() {
    for (int i = 0; i < squaresCount; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveGhost(){
    Random random = new Random();
    int randomValue = random.nextInt(3);
    int step = 0;

    Timer.periodic(Duration(milliseconds: 200), (timer) {

      switch (randomValue) {
        case 0:
          step = -rowsCount;
          break;

        case 1:
          step = rowsCount;
          break;

        case 2:
          step = -1;
          break;

        case 3:
          step = 1;
          break;
        default:
      }

      if (!barriers.contains(ghostPosition + step)) {
        setState(() {
          ghostPosition+=step;
        });
      } else randomValue = random.nextInt(4);

    });
  }

  startGame() {
    moveGhost();
    initFood();

    Timer.periodic(Duration(milliseconds: 400), (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });

      if(food.contains(playerPosition)){
        food.remove(playerPosition);
        score++;
      }


      int step = 0;
      switch (direction) {
        case "down":
          step = -rowsCount;
          break;

        case "up":
          step = rowsCount;
          break;

        case "left":
          step = -1;
          break;

        case "right":
          step = 1;
          break;
        default:
      }

      if (!barriers.contains(playerPosition + step)) {
        setState(() {
          playerPosition+=step;
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
                flex: 5,
                child: GestureDetector(
                  onVerticalDragUpdate: (details){
                    if(details.delta.dy > 0){
                      direction = "up";
                    } else if (details.delta.dy < 0){
                      direction = "down";
                    }
                  },
                  onHorizontalDragUpdate: (details){
                    if(details.delta.dx > 0){
                      direction = "right";
                    } else if (details.delta.dx < 0){
                      direction = "left";
                    }
                  },
                  child: Container(
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: squaresCount,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: rowsCount),
                          itemBuilder: (BuildContext context, int index) {

                            if(playerPosition == ghostPosition){
                              playerPosition = -1;
                            } else
                            if (playerPosition == index) {
                              if(mouthClosed){
                                return Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          shape: BoxShape.circle
                                      )
                                  ),);
                              }

                              switch(direction){
                                case "left":
                                 return Transform.rotate(angle: pi, child: Player());
                                 break;
                                case "down":
                                  return Transform.rotate(angle: 3*pi/2, child: Player());
                                  break;
                                case "up":
                                  return Transform.rotate(angle: pi/2, child: Player());
                                  break;
                                default : return Player();
                              }
                              
                            }
                            else if (ghostPosition == index) {
                              return Ghost();
                            } else if (barriers.contains(index)) {
                              return Pixel(innerColor: Colors.blue[800],
                                  outerColor: Colors.blue[900]);
                            } else if(food.contains(index))
                              return Path(innerColor: Colors.yellow,
                                  outerColor: Colors.black);

                            return Path(innerColor: Colors.black,
                                outerColor: Colors.black);
                          })),
                )
            ),
            Expanded(
                child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Score: "+score.toString(),
                            style: TextStyle(
                                color: Colors.white, fontSize: 30)),

                        GestureDetector(
                            onTap: () => startGame(),
                            child: Text("P L A Y ", style: TextStyle(
                                color: Colors.white, fontSize: 40))
                        )

                      ],
                    )))
          ],
        ));
  }


}