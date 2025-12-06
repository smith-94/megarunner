import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:megarunner/main.dart';
import 'package:megarunner/obstacle.dart';

class Player extends SpriteAnimationComponent
    with HasGameReference<MegaRunnerGame>, CollisionCallbacks {
  final double _jumpForce = 20;
  final double _gravity = 0.9;
  double _velocity = 0;
  bool _isOnGround = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(32, 32),
      ),
    );
    position = Vector2(50, game.size.y - 64);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMounted && game.isGameStarted) {
      _velocity += _gravity;
      position.y += _velocity;

      if (position.y > game.size.y - 64) {
        position.y = game.size.y - 64;
        _velocity = 0;
        _isOnGround = true;
      }
    }
  }

  void jump() {
    if (_isOnGround) {
      _velocity = -_jumpForce;
      _isOnGround = false;
    }
  }

  void reset() {
    position = Vector2(50, game.size.y - 64);
    _velocity = 0;
    _isOnGround = true;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstacle) {
      game.gameOver();
    }
  }
}