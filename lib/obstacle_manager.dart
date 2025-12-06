import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:flame/components.dart';
import 'package:megarunner/main.dart';
import 'package:megarunner/obstacle.dart';

class ObstacleManager extends Component with HasGameReference<MegaRunnerGame> {
  final Random _random = Random();
  double _timeSinceLastObstacle = 0;
  double _obstacleInterval = 2.0;

  @override
  void update(double dt) {
    super.update(dt);

    if (game.isGameStarted) {
      _timeSinceLastObstacle += dt;

      if (_timeSinceLastObstacle > _obstacleInterval) {
        _spawnObstacle();
        _timeSinceLastObstacle = 0;
        _obstacleInterval = _random.nextDouble() * 2.0 + 2.0;
      }
    }
  }

  void _spawnObstacle() {
    final word = nouns.elementAt(_random.nextInt(nouns.length));
    final newObstacle = Obstacle(word);
    game.add(newObstacle);
  }
}