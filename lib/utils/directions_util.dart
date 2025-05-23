import 'package:flame/components.dart';

enum Direction {
  up,
  down,
  left,
  right,
}

class DirectionUtils {
  static Vector2 toVector(Direction dir) {
    switch (dir) {
      case Direction.up:
        return Vector2(0, -1);
      case Direction.down:
        return Vector2(0, 1);
      case Direction.left:
        return Vector2(-1, 0);
      case Direction.right:
        return Vector2(1, 0);
    }
  }

  static int dx(Direction dir) {
    switch (dir) {
      case Direction.left:
        return -1;
      case Direction.right:
        return 1;
      default:
        return 0;
    }
  }

  static int dy(Direction dir) {
    switch (dir) {
      case Direction.up:
        return -1;
      case Direction.down:
        return 1;
      default:
        return 0;
    }
  }
}
