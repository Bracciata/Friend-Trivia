import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class GameScreen extends State<GameScreenStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Setup'),
          leading: new Container(),
        ),
        body: new Center());
  }
}
class GameScreenStatefulWidget extends StatefulWidget {
  @override
  GameScreen createState() => new GameScreen();
}
