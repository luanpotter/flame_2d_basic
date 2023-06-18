import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_2d_basic/components/basic_component.dart';
import 'package:flame_2d_basic/components/box.dart';
import 'package:flame_2d_basic/main.dart';
import 'package:flame_2d_basic/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Player extends BasicComponent with KeyboardHandler {
  static const _playerSpeed = 100.0;
  static const _gravityAcc = 150.0;
  static final _paint = Paint()..color = Colors.pinkAccent;

  final Vector2 move = Vector2.zero();
  final Vector2 velocity = Vector2.zero();

  Player({required super.position})
      : super(
          size: Vector2.all(tileLength),
          paint: _paint,
        );

  @override
  void update(double dt) {
    super.update(dt);

    final previousPosition = position.clone();
    void handleCollisionAndReset() {
      _handleCollision(previousPosition);
      previousPosition.setFrom(position);
    }

    if (gameRef.physicsMode == PhysicsMode.topDown) {
      position.x += move.x * dt * _playerSpeed;
      handleCollisionAndReset();

      position.y += move.y * dt * _playerSpeed;
      handleCollisionAndReset();
    } else {
      position.x += move.x * dt * _playerSpeed;
      handleCollisionAndReset();

      const accY = _gravityAcc;
      final deltaY = accY * dt * dt / 2 + velocity.y * dt;

      velocity.y += accY * dt;
      position.y += deltaY;
      handleCollisionAndReset();
    }

    if (_isOnFloor()) {
      velocity.y = 0;
    }
  }

  void _jump() {
    if (_isOnFloor()) {
      velocity.y = -_playerSpeed;
    }
  }

  bool _isOnFloor() {
    final playerFeet = toRect().bottom;
    return gameRef.boxes.any((box) => playerFeet == box.y);
  }

  void _handleCollision(Vector2 previousPosition) {
    final boxes = _collidingWith();
    if (boxes.isEmpty) {
      return;
    }

    final rects = boxes.map((box) => box.toRect()).toList();

    final ds = position - previousPosition;
    position.setFrom(previousPosition);

    if (ds.x < 0) {
      // going left
      final maxRight = rects.map((rect) => rect.right).reduce(max);
      position.x = position.x = maxRight;
    } else if (ds.x > 0) {
      // going right
      final minLeft = rects.map((rect) => rect.left).reduce(min);
      position.x = minLeft - size.x;
    }

    if (ds.y < 0) {
      // going up
      final minBottom = rects.map((rect) => rect.bottom).reduce(min);
      position.y = minBottom;
    } else if (ds.y > 0) {
      // going down
      final maxTop = rects.map((rect) => rect.top).reduce(max);
      position.y = maxTop - size.y;
    }
  }

  Iterable<Box> _collidingWith() {
    final playerRect = toRect();
    return gameRef.boxes.where((box) => _wouldCollideWithBox(playerRect, box));
  }

  bool _wouldCollideWithBox(Rect playerRect, Box box) {
    return playerRect.overlaps(box.toRect());
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

    if (gameRef.physicsMode == PhysicsMode.platformer) {
      final isDown = event is RawKeyDownEvent;
      if (isDown && event.logicalKey == LogicalKeyboardKey.keyW) {
        _jump();
      }
    }

    return true;
  }
}
