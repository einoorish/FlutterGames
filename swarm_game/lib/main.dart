
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_controller.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences storage = await SharedPreferences.getInstance();

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  GameController gameController = GameController(storage);
  runApp(gameController.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = gameController.onTapDown;
  flameUtil.addGestureRecognizer(tapper);
}
