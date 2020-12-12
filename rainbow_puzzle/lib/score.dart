import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_puzzle/controller.dart';

class ScoreModel extends ChangeNotifier{

  int _value = 0;

  int get value => _value;

  set value(x) {
    _value = x;
    notifyListeners();
  }

}

class ScoreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //ChangeNotifierProvider causes the widget to rebuild itself with the new score value.

    //Flutter doesn’t allow mutable properties on StatelessWidget or direct access to the state of a StatefulWidget,
    //so this is a good solution for updating state on an object and having its widget re-build with any desired conditions.

    return ChangeNotifierProvider.value(
      value: Controller.scoreModel,
      child: Consumer<ScoreModel>(
        builder: (context, model, child){
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top:24, bottom: 12),
                child: Text("s c o r e :"),
              ),
              Text(model.value.toString())
            ]
          );
        }
      )
    );

  }

}