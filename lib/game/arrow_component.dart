import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:wumpus_world_flame/utils/directions_util.dart';

class ArrowComponent extends PositionComponent with HasGameReference {
  ArrowComponent({
    required this.startPosition,
    required this.direction,
    this.tileSize = 64,
  }) {
    position = startPosition;
    size = Vector2(tileSize * 0.6, tileSize * 0.2);
  }

  @override
  Future<void> onLoad() async {}

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.orange;
    canvas.drawRect(size.toRect(), paint);
  }

  Future<void> flyOneTile() async {
    // Convert Direction enum to Vector2 movement
    final moveVector = DirectionUtils.toVector(direction) * tileSize;
    targetPosition = position + moveVector;

    if (!isMounted) {
      game.add(this);
      await game.lifecycleEventsProcessed;
    }

    final effect = MoveEffect.to(
      targetPosition,
      EffectController(duration: 0.15, curve: Curves.linear),
    );

    await add(effect);
  }

  final Vector2 startPosition;
  final Direction direction;
  final double tileSize;
  late Vector2 targetPosition;
}
