import 'package:flutter/material.dart';
import 'gameScreen.dart';
import 'addCharacterScreenFromScratch.dart';

//TODO add buttons to make decision
class PostGameScreen extends State<PostGameScreenScreenStatefulWidget> {
  PostGameScreen({this.players});
  List players;
  @override
  Widget build(BuildContext context) {
    return new Container();
  }

  void openGameSameNames() {
    List names = new List();
    players.forEach((item) {
      names.add(item.name);
    });
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                new GameScreenStatefulWidget(names: names)),
        (Route<dynamic> route) {
      return false;
    });
  }

  void openNameSeletion() {
     Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                new CharacterScreenStatefulWidget()),
        (Route<dynamic> route) {
      return false;
    });
  }
}

class PostGameScreenScreenStatefulWidget extends StatefulWidget {
  PostGameScreenScreenStatefulWidget({this.players});
  final List players;
  @override
  PostGameScreen createState() => new PostGameScreen(players: this.players);
}
