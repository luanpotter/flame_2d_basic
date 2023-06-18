import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_2d_basic/main.dart';
import 'package:flutter/material.dart';

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
