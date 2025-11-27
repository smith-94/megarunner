import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart'; // Added for Colors
import 'package:megarunner/main.dart';

class Obstacle extends RectangleComponent with HasGameRef<MegaRunnerGame> {
  Obstacle()
      : super(
          size: Vector2(50, 50), // Default size, can be varied
          paint: Paint()..color = Colors.red, // Red color for obstacles
        ) {
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(game.size.x, game.size.y - 100); // Initial position off-screen right
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= game.currentSpeed * dt;
    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}
