import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart'; // Added for Colors
import 'package:megarunner/main.dart';

class Ground extends PositionComponent with HasGameRef<MegaRunnerGame> {
  final Random _random = Random();
  static const double _segmentWidth = 200.0;
  static const int _maxSegments = 10;
  static const double _gapProbability = 0.2;
  static const int _maxGapLength = 2;

  int _currentGapLength = 0;

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

    for (final child in children.whereType<PositionComponent>().toList()) { // Changed from SpriteComponent to PositionComponent
      child.position.x -= currentGroundSpeed * dt;
      if (child.position.x < -_segmentWidth) {
        child.removeFromParent();
        _addSegment((_maxSegments - 1) * _segmentWidth + child.size.x);
      }
    }
  }

  void _addSegment(double x) { // No longer async
    bool isGap = _random.nextDouble() < _gapProbability;

    if (isGap && _currentGapLength >= _maxGapLength) {
      isGap = false;
    }

    if (isGap) {
      _currentGapLength++;
    } else {
      _currentGapLength = 0;
      final segment = RectangleComponent(
        size: Vector2(_segmentWidth, 50),
        position: Vector2(x, game.size.y - 50),
        paint: Paint()..color = Colors.green, // Use a green color for ground
      );
      segment.add(RectangleHitbox());
      add(segment);
    }
  }
}
