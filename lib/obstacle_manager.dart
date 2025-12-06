import 'dart:math';
import 'package:flame/components.dart';
import 'package:megarunner/main.dart';
import 'package:megarunner/obstacle.dart';

class ObstacleManager extends Component with HasGameReference<MegaRunnerGame> {
  final Random _random = Random();
  double _timeSinceLastObstacle = 0;
  double _obstacleInterval = 2.0;
  late final Sprite _obstacleSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _obstacleSprite = await game.loadSprite('obstacle.png');
  }

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
    final newObstacle = Obstacle()
      ..sprite = _obstacleSprite
      ..position = Vector2(game.size.x, game.size.y - 82);
    game.add(newObstacle);
  }
}
