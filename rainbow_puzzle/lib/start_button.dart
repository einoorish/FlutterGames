import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller.dart';

class ButtonModel extends ChangeNotifier{

  String _text = "s t a r t";

  String get text => _text;
  set text(x) {
    _text = x;
    notifyListeners();
  }
}



class StartButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Controller.buttonModel,
        child: Consumer<ButtonModel>(
          builder: (context, model, child){
            return Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                    height: 64,
                    width: double.infinity,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: MaterialButton(
                          color: Colors.transparent,
                          onPressed: Controller.start,
                          child: Text(Controller.buttonModel._text),
                        )
                    )
                )
            );
          },
        )
    );
  }
}