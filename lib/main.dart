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
import 'package:flutter_tts/flutter_tts.dart';
import 'package:megarunner/player.dart';
import 'package:megarunner/word.dart';
import 'package:megarunner/word_manager.dart';

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
  late FlutterTts flutterTts;
  int score = 0;
  bool _isGameOver = false;

  bool get isGameStarted => !_isGameOver;
  double get gameSpeed => currentSpeed;

  // Dynamic Speed Variables
  static const double _baseSpeed = 120.0;
  static const double _speedIncreaseFactor = 5.0; // How fast the speed increases over time
  static const double _maxSpeed = 350.0; // Maximum speed limit, adjusted to be not too fast
  static const double _speedChangeInterval = 5.0; // How often the target speed changes
  double _timeElapsed = 0.0;
  double currentSpeed = _baseSpeed;
  double _targetSpeed = _baseSpeed; // New variable for target speed
  double _timeSinceLastSpeedChange = 0.0;
  final Random _random = Random(); // For random speed changes

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
    children.whereType<WordManager>().forEach((wm) => wm.removeFromParent()); // Remove existing WordManager
    children.whereType<Word>().forEach((w) => w.removeFromParent()); // Remove existing Words

    score = 0;
    _isGameOver = false;
    _timeElapsed = 0.0;
    currentSpeed = _baseSpeed;
    _targetSpeed = _baseSpeed;
    _timeSinceLastSpeedChange = 0.0;

    add(Background());
    add(Ground());
    add(ObstacleManager());
    add(WordManager()); // Add WordManager
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

    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_isGameOver) {
      _timeElapsed += dt;
      _timeSinceLastSpeedChange += dt;

      // Gradually adjust currentSpeed towards _targetSpeed
      currentSpeed = currentSpeed + (_targetSpeed - currentSpeed) * 0.01;

      // Increase target speed over time
      _targetSpeed = (_baseSpeed + _timeElapsed * _speedIncreaseFactor)
          .clamp(_baseSpeed, _maxSpeed);

      // Randomly change target speed within a range
      if (_timeSinceLastSpeedChange >= _speedChangeInterval) {
        _timeSinceLastSpeedChange = 0.0;
        final double randomFactor = _random.nextDouble() * 0.4 - 0.2; // -0.2 to 0.2
        _targetSpeed = (_targetSpeed * (1 + randomFactor))
            .clamp(_baseSpeed, _maxSpeed);
      }

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