import 'package:wumpus_world_flame/models/room_model.dart';

void generateWorld(List<List<RoomModel>> world) {
  const int size = 4;

  bool isValid(int x, int y) => x >= 0 && y >= 0 && x < size && y < size;

  final position = <List<int>>[];
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      if (x == 0 && y == 0) continue;
      position.add([x, y]);
    }
  }
  position.shuffle();

  final goldPos = position.removeLast();
  world[goldPos[0]][goldPos[1]].hasGold = true;

  final wumpusPos = position.removeLast();
  world[wumpusPos[0]][wumpusPos[1]].hasWumpus = true;

  for (int i = 0; i < 3; i++) {
    final pitpos = position.removeLast();
    world[pitpos[0]][pitpos[1]].hasPit = true;
  }

  void addPerceptAround(int x, int y, String percept) {
    for (var dx in [-1, 0, 1]) {
      for (var dy in [-1, 0, 1]) {
        if ((dx.abs() + dy.abs()) != 1) continue;
        int nx = x + dx;
        int ny = y + dy;
        if (isValid(nx, ny)) {
          world[nx][ny].percepts.add(percept);
        }
      }
    }
  }

  addPerceptAround(goldPos[0], goldPos[1], "glitter");
  addPerceptAround(wumpusPos[0], wumpusPos[1], "stench");

  for (var row in world) {
    for (var room in row) {
      if (room.hasPit) {
        addPerceptAround(room.x, room.y, "breeze");
      }
    }
  }
}
