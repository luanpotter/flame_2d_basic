import 'dart:ui';

import 'package:flame/components.dart';

class Box extends PositionComponent {
  final _paint = Paint()..color = const Color(0xFF0000FF);
  Rect? _sizeRect;

  Box(Vector2 position, Vector2 size) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(_sizeRect ??= size.toRect(), _paint);
  }
}
