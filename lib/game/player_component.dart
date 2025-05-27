import 'package:flame/components.dart';

class PlayerComponent extends PositionComponent {
  int gridX, gridY;
  int arrow = 3;
  bool hasGold = false;

  PlayerComponent({required int startX, required int startY})
      : gridX = startX,
        gridY = startY;

  void moveBy(int dx, int dy) {
    gridX += dx;
    gridY += dy;
    position = Vector2(gridX * 64.0, gridY * 64.0);
  }

  @override
  Future<void> onLoad() async {
    size = Vector2.all(64);
    position = Vector2(gridX * 64.0, gridY * 64.0);
    // TODO: Load player sprite/animation
  }
}
