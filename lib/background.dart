import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:megarunner/main.dart';

class Background extends PositionComponent with HasGameReference<MegaRunnerGame> {
  Background() : super(priority: -1); // Draw behind other components

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      RectangleComponent(
        size: game.size,
        paint: Paint()..color = Colors.lightBlueAccent, // A light blue for the sky
      ),
    );
  }
}
