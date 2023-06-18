import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_2d_basic/box_generator.dart';
import 'package:flame_2d_basic/components/box.dart';
import 'package:flame_2d_basic/components/player.dart';
import 'package:flame_2d_basic/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(GameWidget(game: Flame2dGame()));
}

enum CameraMode {
  none,
  fixedAspect,
  expand;

  CameraMode next() {
    return CameraMode.values[(index + 1) % CameraMode.values.length];
  }
}

enum PhysicsMode {
  topDown,
  platformer;

  PhysicsMode next() {
    return PhysicsMode.values[(index + 1) % PhysicsMode.values.length];
  }
}

class Flame2dGame extends FlameGame with HasKeyboardHandlerComponents {
  static final Paint _bg = Paint()..color = Colors.grey;
  static final Paint _cameraBorder = Paint()
    ..color = Colors.amber
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  CameraMode cameraMode = CameraMode.none;
  PhysicsMode physicsMode = PhysicsMode.topDown;

  late Player player;
  Vector2 cameraPosition = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await addAll(generateBoxes());
    await add(player = Player(position: (worldSize - tileSize) / 2));

    return super.onLoad();
  }

  Iterable<Box> get boxes {
    return children.whereType<Box>();
  }

  @override
  void render(Canvas canvas) {
    // NOTE: these transformations are equivalent to different configurations
    // of the built-in CameraComponent:
    // https://docs.flame-engine.org/latest/flame/camera_component.html
    switch (cameraMode) {
      case CameraMode.none:
        noCamera(canvas);
        break;
      case CameraMode.fixedAspect:
        fixedAspectCamera(canvas);
        break;
      case CameraMode.expand:
        expandCamera(canvas);
        break;
    }

    canvas.drawRect(Vector2.zero() & worldSize, _bg);
    super.render(canvas);
    canvas.drawRect(
      (cameraPosition - screenSize / 2) & screenSize,
      _cameraBorder,
    );
  }

  void noCamera(Canvas canvas) {
    final scale = size.clone()..divide(worldSize);
    canvas.scaleVector(scale);

    // equivalent matrix4 transform
    // canvas.transform(
    //   (Matrix4.identity()..scale(scale.x, scale.y, 1)).storage,
    // );
  }

  void fixedAspectCamera(Canvas canvas) {
    final scale = min(size.x / screenSize.x, size.y / screenSize.y);
    canvas.scale(scale);
    canvas.translateVector((size / scale - screenSize) / 2);
    canvas.clipRect(screenSize.toRect());

    canvas.translateVector(-cameraPosition + screenSize / 2);

    // equivalent matrix4 transform
    // canvas.transform(
    //   (Matrix4.identity()..translate2(-cameraPosition + screenSize / 2))
    //       .storage,
    // );
  }

  void expandCamera(Canvas canvas) {
    final scale = size.clone()..divide(screenSize);

    canvas.scaleVector(scale);
    canvas.translateVector(-cameraPosition + screenSize / 2);

    // equivalent matrix4 transform
    // canvas.transform(
    //   (Matrix4.identity()
    //         ..scale(scale.x, scale.y, 1)
    //         ..translate2(-cameraPosition + screenSize / 2))
    //       .storage,
    // );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // camera follow
    cameraPosition = player.position + player.size / 2;
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isDown = event is RawKeyDownEvent;
    if (isDown) {
      if (event.logicalKey == LogicalKeyboardKey.keyM) {
        cameraMode = cameraMode.next();
      } else if (event.logicalKey == LogicalKeyboardKey.keyP) {
        physicsMode = physicsMode.next();
        player.velocity.setZero();
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
