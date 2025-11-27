import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:megarunner/background.dart';
import 'package:megarunner/game_over_overlay.dart';
import 'package:megarunner/ground.dart';
import 'package:megarunner/obstacle.dart';
import 'package:megarunner/obstacle_manager.dart';
import 'package:megarunner/player.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final MegaRunnerGame _game;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _game = MegaRunnerGame();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: _game,
          focusNode: _focusNode,
          autofocus: true,
          overlayBuilderMap: {
            'GameOver': (BuildContext context, MegaRunnerGame game) {
              return GameOverOverlay(game: game);
            },
          },
        ),
      ),
    );
  }
}

class MegaRunnerGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  late Player _player;
  late TextComponent _scoreText;
  int score = 0;
  bool _isGameOver = false;

  // Dynamic Speed Variables
  static const double _baseSpeed = 200.0;
  static const double _speedAmplitude = 50.0;
  static const double _speedFrequency = 0.5; // How fast the speed fluctuates
  double _timeElapsed = 0.0;
  double currentSpeed = _baseSpeed;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initializeGame();
  }

  void _initializeGame() {
    children.whereType<Player>().forEach((p) => p.removeFromParent());
    children.whereType<Ground>().forEach((g) => g.removeFromParent());
    children.whereType<Background>().forEach((b) => b.removeFromParent());
    children.whereType<Obstacle>().forEach((o) => o.removeFromParent());
    children.whereType<ObstacleManager>().forEach((om) => om.removeFromParent());

    score = 0;
    _isGameOver = false;
    _timeElapsed = 0.0;

    add(Background());
    add(Ground());
    add(ObstacleManager());
    _player = Player();
    add(_player);

    _scoreText = TextComponent(
      text: 'Score: 0',
      anchor: Anchor.topRight,
      position: Vector2(size.x - 20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
    add(_scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_isGameOver) {
      _timeElapsed += dt;
      currentSpeed = _baseSpeed + _speedAmplitude * sin(_speedFrequency * _timeElapsed);

      score++;
      _scoreText.text = 'Score: $score';
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_isGameOver) {
      _player.jump();
    }
  }

  void gameOver() {
    if (!_isGameOver) {
      _isGameOver = true;
      overlays.add('GameOver');
      pauseEngine();
    }
  }

  void restart() {
    overlays.remove('GameOver');
    _initializeGame();
    resumeEngine();
  }
}