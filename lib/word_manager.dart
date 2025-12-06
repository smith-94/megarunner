import 'dart:math';

import 'package:flame/components.dart';
import 'package:megarunner/main.dart';
import 'package:megarunner/word.dart';

class WordManager extends Component with HasGameReference<MegaRunnerGame> {
  final Random _random = Random();
  final double _minSpawnTime = 5.0;
  final double _maxSpawnTime = 10.0;
  double _currentSpawnTime = 0.0;
  double _timeSinceLastSpawn = 0.0;

  @override
  void onMount() {
    super.onMount();
    _currentSpawnTime = _minSpawnTime +
        (_random.nextDouble() * (_maxSpawnTime - _minSpawnTime));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameStarted) {
      _timeSinceLastSpawn += dt;
      if (_timeSinceLastSpawn >= _currentSpawnTime) {
        _timeSinceLastSpawn = 0.0;
        _currentSpawnTime = _minSpawnTime +
            (_random.nextDouble() * (_maxSpawnTime - _minSpawnTime));
        _spawnWord();
      }
    }
  }

  void _spawnWord() {
    game.add(Word());
  }

  void removeAllWords() {
    parent?.children.whereType<Word>().forEach((word) {
      word.removeFromParent();
    });
  }
}
