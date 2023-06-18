import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/services.dart';

const tileLength = 16.0;
final tileSize = Vector2.all(tileLength);
final worldSize = Vector2.all(30) * tileLength;
final screenSize = Vector2(16, 9) * tileLength;

Vector2 minVector2(Vector2 a, Vector2 b) {
  return Vector2(min(a.x, b.x), min(a.y, b.y));
}

void readArrowLikeKeysIntoVector2(
  RawKeyEvent event,
  Set<LogicalKeyboardKey> keysPressed,
  Vector2 vector, {
  required LogicalKeyboardKey up,
  required LogicalKeyboardKey down,
  required LogicalKeyboardKey left,
  required LogicalKeyboardKey right,
}) {
  final isDown = event is RawKeyDownEvent;
  if (event.logicalKey == up) {
    if (isDown) {
      vector.y = -1;
    } else if (keysPressed.contains(down)) {
      vector.y = 1;
    } else {
      vector.y = 0;
    }
  } else if (event.logicalKey == down) {
    if (isDown) {
      vector.y = 1;
    } else if (keysPressed.contains(up)) {
      vector.y = -1;
    } else {
      vector.y = 0;
    }
  } else if (event.logicalKey == left) {
    if (isDown) {
      vector.x = -1;
    } else if (keysPressed.contains(right)) {
      vector.x = 1;
    } else {
      vector.x = 0;
    }
  } else if (event.logicalKey == right) {
    if (isDown) {
      vector.x = 1;
    } else if (keysPressed.contains(left)) {
      vector.x = -1;
    } else {
      vector.x = 0;
    }
  }
}
