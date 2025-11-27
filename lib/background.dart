import 'package:flame/components.dart';
import 'package:flutter/material.dart'; // Added for Colors
import 'package:megarunner/main.dart';

class Background extends RectangleComponent with HasGameRef<MegaRunnerGame> {
  Background()
      : super(
          paint: Paint()..color = Colors.lightBlueAccent, // A light blue for the sky
          priority: -1, // Draw behind other components
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = game.size; // Make background fill the entire screen
  }
}
