import 'dart:math';
import 'package:flame/components.dart';
import 'package:megarunner/main.dart';
import 'package:megarunner/obstacle.dart';

class ObstacleManager extends Component with HasGameRef<MegaRunnerGame> {
  final Random _random = Random();
  final double _minSpawnTime = 2.0;
  final double _maxSpawnTime = 4.0;
  double _currentSpawnTime = 0.0;
  double _timeSinceLastSpawn = 0.0;

  @override
  void onMount() {
    super.onMount();
    _currentSpawnTime = _minSpawnTime + (_random.nextDouble() * (_maxSpawnTime - _minSpawnTime));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastSpawn += dt;

    if (_timeSinceLastSpawn >= _currentSpawnTime) {
      _timeSinceLastSpawn = 0.0;
      _currentSpawnTime = _minSpawnTime + (_random.nextDouble() * (_maxSpawnTime - _minSpawnTime));
      game.add(Obstacle());
    }
  }
}