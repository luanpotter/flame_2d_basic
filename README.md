# flame_2d_basic

Simple example project showcasing the basics of 2d transformations.

This game intentionally does not use the built-in Camera system from Flame; instead it has simple implementations of multiple types of coordinate transformations for basic 2d games. You can change the camera mode by pressing `M`.

It also includes two possible choices for physics system; top-down or platformer. Press `P` to switch between them.

## 2d Projections

These are the projections available in the game:

### No camera

Just scales to screen size. Does not translate. Does not preserve aspect ratio.

```dart
    final scale = size.clone()..divide(worldSize);
    canvas.scaleVector(scale);
```

Or in matrix form:
```dart
    final scale = size.clone()..divide(worldSize);
    canvas.transform(
      (Matrix4.identity()..scale(scale.x, scale.y, 1)).storage,
    );
```

### Fixed Aspect Ratio Camera

Setup:

```dart
    final scale = min(size.x / screenSize.x, size.y / screenSize.y);
    canvas.scale(scale);
    canvas.translateVector((size / scale - screenSize) / 2);
    canvas.clipRect(screenSize.toRect());
```

Basic version:

```dart
    canvas.translateVector(-cameraPosition + screenSize / 2);
```

Or in matrix form:

```dart
    canvas.transform(
      (Matrix4.identity()..translate2(-cameraPosition + screenSize / 2))
          .storage,
    );
```

### Expand Camera

Expand to fit the canvas. Does not respect aspect ratio.

```dart
    final scale = size.clone()..divide(screenSize);

    canvas.scaleVector(scale);
    canvas.translateVector(-cameraPosition + screenSize / 2);
```

Or in matrix form:

```dart
    canvas.transform(
      (Matrix4.identity()
            ..scale(scale.x, scale.y, 1)
            ..translate2(-cameraPosition + screenSize / 2))
          .storage,
    );
```