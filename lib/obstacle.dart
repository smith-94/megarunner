import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:megarunner/main.dart';

class Obstacle extends PositionComponent with HasGameReference<MegaRunnerGame> {
  final String word;

  Obstacle(this.word);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 32,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );

    final textComponent = TextComponent(
      text: word,
      textRenderer: textRenderer,
      anchor: Anchor.bottomLeft,
    );

    size = textComponent.size;
    position = Vector2(game.size.x, game.size.y - 32);

    add(textComponent);
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
