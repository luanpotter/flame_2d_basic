import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame_2d_basic/basic_component.dart';
import 'package:flame_2d_basic/utils.dart';

const _numBoxes = 30;
final _r = Random();

List<Box> generateBoxes() {
  return [
    // walls
    Box(Vector2(0, 0), Vector2(worldSize.x, tileLength)),
    Box(Vector2(0, 0), Vector2(tileLength, worldSize.y)),
    Box(Vector2(0, worldSize.y - tileLength), Vector2(worldSize.x, tileLength)),
    Box(Vector2(worldSize.x - tileLength, 0), Vector2(tileLength, worldSize.y)),

    // central platform
    Box(
      Vector2((worldSize.x - 3 * tileLength) / 2, worldSize.y / 2 + tileLength),
      Vector2(3 * tileLength, tileLength),
    ),

    ..._randomBoxes(worldSize),
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
        _r.nextInt(worldSize.x ~/ tileLength).toDouble() * tileLength,
        _r.nextInt(worldSize.y ~/ tileLength).toDouble() * tileLength,
      ),
      size * tileLength,
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
