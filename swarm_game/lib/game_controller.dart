import 'dart:math';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:swarm_game/components/enemy.dart';
import 'package:swarm_game/components/health_bar.dart';
import 'package:swarm_game/components/highscore_text.dart';
import 'package:swarm_game/components/player.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:swarm_game/components/start_button.dart';
import 'package:swarm_game/enemy_spawner.dart';

import 'components/score_text.dart';
import 'components/state.dart';


class GameController extends Game {
  final SharedPreferences storage;
  Size screenSize;
  double tileSize;
  Player player;
  List<Enemy> enemies;
  EnemySpawner enemySpawner;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  HighscoreText highscoreText;
  StartText startText;
  State state;

  GameController(this.storage){
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = State.menu;
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);
    spawnEnemy();
    score = 0;
  }

  @override
  void render(Canvas canvas) {
    Rect background = Rect.fromLTWH(0,0,screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    canvas.drawRect(background,backgroundPaint);

    player.render(canvas);

    if(state == State.menu){
      startText.render(canvas);
      highscoreText.render(canvas);
    }else {
      enemies.forEach((Enemy enemy) => enemy.render(canvas));
      healthBar.render(canvas);
      scoreText.render(canvas);
    }
  }

  @override
  void update(double t) {
    if(state == State.menu){
      startText.update(t);
      highscoreText.update(t);
    } else {
      enemySpawner.update(t);
      enemies.forEach((Enemy enemy) => enemy.update(t));
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(t);
      healthBar.update(t);
      scoreText.update(t);
    }
  }

  void resize(Size size){
    screenSize = size;
    tileSize = screenSize.width/10;
  }

  void onTapDown(TapDownDetails d){
    if(state == State.menu){
      state = State.playing;
    } else {
      enemies.forEach((Enemy enemy) {
        if(enemy.enemyRect.contains(d.globalPosition)){
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    Random rand = Random();
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
      // Top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
      // Right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
      // Bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
      // Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}