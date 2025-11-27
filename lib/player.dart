import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:megarunner/ground.dart';
import 'package:megarunner/main.dart';
import 'package:megarunner/obstacle.dart';

class Player extends RectangleComponent
    with HasGameRef<MegaRunnerGame>, CollisionCallbacks {
  static const double _gravity = 800.0;
  static const double _jumpForce = -400.0;

  final Vector2 _velocity = Vector2.zero();
  bool _isGrounded = false;
  int _jumpCount = 0;

  Player()
      : super(
          size: Vector2.all(60),
          paint: Paint()..color = Colors.blue,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(50, game.size.y - 100);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    if (!_isGrounded) {
      _velocity.y += _gravity * dt;
    }

    position += _velocity * dt;

    if (position.y > game.size.y) {
      game.gameOver();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is SpriteComponent && other.parent is Ground) {
      if (_velocity.y > 0) {
        // If falling, stop at the ground
        _velocity.y = 0;
        position.y = other.absolutePosition.y - size.y;
        _isGrounded = true;
        _jumpCount = 0;
      }
    } else if (other is Obstacle) {
      game.gameOver();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is SpriteComponent && other.parent is Ground) {
      _isGrounded = false;
    }
  }

  void jump() {
    if (_isGrounded || _jumpCount < 2) {
      _velocity.y = _jumpForce;
      _isGrounded = false;
      _jumpCount++;
    }
  }
}
