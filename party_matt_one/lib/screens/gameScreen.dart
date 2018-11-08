import 'package:flutter/material.dart';

//TODO is begin game using players names
class GameScreen extends State<GameScreenStatefulWidget> {
  List names;
  GameScreen({this.names});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Game'),
          leading: new Container(),
        ),
        body: new Center(
            child: ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return new ListTile(
                      key: Key(index.toString()),
                      title: new Text(names[index]));
                })));
  }
}

class GameScreenStatefulWidget extends StatefulWidget {
  GameScreenStatefulWidget({this.names});
  final List names;
  @override
  GameScreen createState() => new GameScreen(names: names);
}
