import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rainbow_puzzle/score.dart';
import 'package:rainbow_puzzle/start_button.dart';

import 'board.dart';

void main() {

  //Ensure that Flutter widgets are initialized before applying orientation lock.
  WidgetsFlutterBinding.ensureInitialized();
  //Apply orientation lock before running the game
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(Game());
}

class Game extends StatelessWidget {

  final String _title = "Rainbow Puzzle";

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: _title,
            theme: ThemeData.dark(),
            home: Scaffold(
                appBar: AppBar(title: Center(child: Text(_title))),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ScoreView(),
                    GameBoard(),
                    StartButtonView()
                  ],
                )
            )
        )
    );
  }
}
