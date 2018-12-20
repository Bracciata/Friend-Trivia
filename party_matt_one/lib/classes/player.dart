class Player {
  String name;
  int pointsThisRound;
  int pointsTotal;
  Player(String name) {
    this.name = name;
    pointsThisRound = 0;
    pointsTotal = 0;
  }
  void choosen() {
    pointsThisRound += 1;
    pointsTotal += 1;
  }

  void endOfRound() {
    pointsThisRound = 0;
  }
}