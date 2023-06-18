import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_2d_basic/box_generator.dart';
import 'package:flame_2d_basic/player.dart';
import 'package:flame_2d_basic/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    final world = World();

    final cameraComponent = CameraComponent.withFixedResolution(
      world: world,
      width: fixedSize.x,
      height: fixedSize.y,
    )..moveTo(fixedSize / 2);
    await add(cameraComponent);

    await world.addAll(generateBoxes(fixedSize));
    await world.add(Player(position: fixedSize / 2));
    await add(world);

    return super.onLoad();
  }
}
