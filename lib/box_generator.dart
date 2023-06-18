import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame_2d_basic/box.dart';
import 'package:flame_2d_basic/utils.dart';

const _numBoxes = 30;
final _r = Random();

List<Box> generateBoxes(Vector2 gameSize) {
  return [
    // walls
    Box(Vector2(0, 0), Vector2(gameSize.x, tileSize)),
    Box(Vector2(0, 0), Vector2(tileSize, gameSize.y)),
    Box(Vector2(0, gameSize.y - tileSize), Vector2(gameSize.x, tileSize)),
    Box(Vector2(gameSize.x - tileSize, 0), Vector2(tileSize, gameSize.y)),

    // central platform
    Box(
      Vector2((fixedSize.x - 3 * tileSize) / 2, fixedSize.y / 2 + tileSize),
      Vector2(3 * tileSize, tileSize),
    ),

    ..._randomBoxes(gameSize),
  ];
}

List<Box> _randomBoxes(Vector2 gameSize) {
  final boxes = <Box>[];
  while (boxes.length < _numBoxes) {
    final shortDimension = _r.nextInt(2) + 1;
    final longDimension = _r.nextInt(5) + 1;
    final (xDimension, yDimension) = _r.nextBool()
        ? (shortDimension, longDimension)
        : (longDimension, shortDimension);
    final size = Vector2(xDimension.toDouble(), yDimension.toDouble());
    final potentialBox = Box(
      Vector2(
        _r.nextInt(fixedSize.x ~/ tileSize).toDouble() * tileSize,
        _r.nextInt(fixedSize.y ~/ tileSize).toDouble() * tileSize,
      ),
      size * tileSize,
    );
    if (boxes.any((box) => _overlaps(box, potentialBox))) {
      continue;
    }
    boxes.add(potentialBox);
  }
  return boxes;
}

bool _overlaps(Box box, Box potentialBox) {
  return false;
}
