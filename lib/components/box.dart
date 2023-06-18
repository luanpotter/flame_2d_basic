import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_2d_basic/components/basic_component.dart';
import 'package:flutter/material.dart';

class Box extends BasicComponent {
  static final _paint = Paint()..color = Colors.blueGrey;

  Box(Vector2 position, Vector2 size)
      : super(position: position, size: size, paint: _paint);
}
