import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_2d_basic/main.dart';
import 'package:flame_2d_basic/utils.dart';
import 'package:flutter/services.dart';

class BasicComponent extends PositionComponent with HasGameRef<Flame2dGame> {
  final Paint paint;
  Rect? _sizeRect;

  BasicComponent({
    required super.position,
    required super.size,
    required this.paint,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(_sizeRect ??= size.toRect(), paint);
  }
}

class Box extends BasicComponent {
  static final _paint = Paint()..color = const Color(0xFF0000FF);

  Box(Vector2 position, Vector2 size)
      : super(position: position, size: size, paint: _paint);
}

class Player extends BasicComponent with KeyboardHandler {
  static const _playerSpeed = 100.0;
  static final _paint = Paint()..color = const Color(0xFFFF00FF);

  final Vector2 move = Vector2.zero();

  Player({required super.position})
      : super(
          size: Vector2.all(tileSize),
          paint: _paint,
        ) {
    anchor = Anchor.center;
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
