class Room {
  final int x, y;
  bool hasWumpus = false;
  bool hasPit = false;
  bool hasGold = false;
  bool isVisible = false;
  Set<String> percepts = {};

  Room(this.x, this.y);
}
