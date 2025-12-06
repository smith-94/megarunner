import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:megarunner/main.dart';

class Obstacle extends SpriteComponent with HasGameReference<MegaRunnerGame> {
  Obstacle() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameStarted) {
      x -= game.gameSpeed * dt;
    }

    if (x < -width) {
      removeFromParent();
    }
  }
}