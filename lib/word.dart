import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:megarunner/main.dart';

class Word extends TextComponent with HasGameReference<MegaRunnerGame> {
  static final Random _random = Random();
  static const List<String> _words = ['FLUTTER', 'DART', 'GAME', 'CODE', 'RUN']; // Example words

  Word() : super(
          text: _words[_random.nextInt(_words.length)],
          textRenderer: TextPaint(
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 30.0 + _random.nextDouble() * 10.0, // Random font size
              fontWeight: FontWeight.bold,
            ),
          ),
          anchor: Anchor.center,
        ) {
    debugMode = true; // Re-enable debug mode to see the hitbox
    priority = 0; // Set priority for the Word component itself
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Position randomly between 20% and 60% of screen height
    position.y = game.size.y * (0.2 + _random.nextDouble() * 0.4);
    position.x = game.size.x + width; // Start off-screen
  }

  @override
  void onMount() {
    super.onMount();
    // Add hitbox here, after the component is mounted and size is determined
    add(RectangleHitbox(size: size, isSolid: true, collisionType: CollisionType.active));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMounted && game.isGameStarted) {
      position.x -= game.currentSpeed * dt;
      if (position.x < -width) {
        removeFromParent();
      }
    }
  }
}
