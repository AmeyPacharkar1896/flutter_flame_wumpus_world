class ScoreModel {
  int score = 0;
  int movesTaken = 0;
  int arrowsUsed = 0;
  bool hasGold = false;
  bool isAlive = true;

  // Constants based on suggested scoring rules
  static const int movePenalty = -2;
  static const int arrowValue = 25;
  static const int goldValue = 200;
  static const int aliveBonus = 200;
  static const int deathPenalty = -200;

  void reset() {
    score = 0;
    movesTaken = 0;
    arrowsUsed = 0;
    hasGold = false;
    isAlive = true;
  }

  void moveMade() {
    movesTaken++;
    score += movePenalty;
  }

  void arrowUsed() {
    arrowsUsed++;
  }

  void collectGold() {
    hasGold = true;
    score += goldValue;
  }

  void died() {
    isAlive = false;
    score += deathPenalty;
  }

  void addSurvivalBonus() {
    if (isAlive) {
      score += aliveBonus;
    }
  }

  void addArrowBonus(int arrowsLeft) {
    score += arrowsLeft * arrowValue;
  }
}
