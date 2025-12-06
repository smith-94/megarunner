import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:megarunner/ground.dart';
import 'package:megarunner/main.dart';
import 'package:megarunner/obstacle.dart';

class Player extends SpriteComponent
    with HasGameReference<MegaRunnerGame>, CollisionCallbacks {
  final double _jumpForce = 20;
  final double _gravity = 0.9;
  double _velocity = 0;
  bool _isOnGround = true;
  int _jumpCount = 0;
  final int _maxJumps = 2; // Allow double jump

  Player() : super(size: Vector2.all(64));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('runner.png');
    position = Vector2(50, game.size.y - 64 - 32);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMounted && game.isGameStarted) {
      if (!_isOnGround) {
        _velocity += _gravity;
        position.y += _velocity;
      }

      // Ensure player never goes below ground level
      final double groundY = game.size.y - 50 - height;
      if (position.y > groundY) {
        position.y = groundY;
        _velocity = 0;
        _isOnGround = true;
        _jumpCount = 0;
      }
    }
  }

  void jump() {
    if (_isOnGround || _jumpCount < _maxJumps) {
      _velocity = -_jumpForce;
      _isOnGround = false;
      _jumpCount++;
    }
  }

  void reset() {
    position = Vector2(50, game.size.y - 64 - 32);
    _velocity = 0;
    _isOnGround = true;
    _jumpCount = 0;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstacle) {
      game.gameOver();
    } else if (other is RectangleComponent && other.parent is Ground) {
      if (_velocity > 0) {
        _velocity = 0;
        position.y = game.size.y - 50 - height; // Explicitly use ground's top Y
        _isOnGround = true;
        _jumpCount = 0; // Reset jump count on landing
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is RectangleComponent && other.parent is Ground) {
      _isOnGround = false;
    }
  }
}
