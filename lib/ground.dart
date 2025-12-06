import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:megarunner/main.dart';

class Ground extends PositionComponent with HasGameReference<MegaRunnerGame> {
  static const double _segmentWidth = 200.0;
  static const int _maxSegments = 10;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    for (int i = 0; i < _maxSegments; i++) {
      _addSegment(i * _segmentWidth);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final double currentGroundSpeed = game.currentSpeed;

    for (final child in children.whereType<PositionComponent>().toList()) {
      child.position.x -= currentGroundSpeed * dt;
      if (child.position.x < -_segmentWidth) {
        child.removeFromParent();
        _addSegment((_maxSegments - 1) * _segmentWidth);
      }
    }
  }

  void _addSegment(double x) {
    final segment = RectangleComponent(
      size: Vector2(_segmentWidth, 50),
      position: Vector2(x, game.size.y - 50),
      paint: Paint()..color = Colors.green,
    );
    segment.add(RectangleHitbox());
    add(segment);
  }
}
