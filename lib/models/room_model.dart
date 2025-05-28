class RoomModel {
  final int x, y;
  bool hasWumpus = false;
  bool hasPit = false;
  bool hasGold = false;
  bool isVisible = false;
  Set<String> percepts = {};

  RoomModel(this.x, this.y);

  RoomModel clone() {
    RoomModel copy = RoomModel(x, y);
    copy.hasGold = hasGold;
    copy.hasPit = hasPit;
    copy.hasWumpus = hasWumpus;
    copy.percepts.addAll(percepts);
    copy.isVisible = isVisible;
    return copy;
  }
}
