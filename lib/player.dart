import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_2d_basic/utils.dart';
import 'package:flutter/services.dart';

class Player extends PositionComponent with KeyboardHandler {
  static const _playerSpeed = 100.0;
  static final _paint = Paint()..color = const Color(0xFFFF00FF);

  final Vector2 move = Vector2.zero();

  Player({required super.position})
      : super(
          size: Vector2.all(tileSize),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += move * dt * _playerSpeed;
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    readArrowLikeKeysIntoVector2(
      event,
      keysPressed,
      move,
      up: LogicalKeyboardKey.keyW,
      left: LogicalKeyboardKey.keyA,
      down: LogicalKeyboardKey.keyS,
      right: LogicalKeyboardKey.keyD,
    );

    return true;
  }
}
