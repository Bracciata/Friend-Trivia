import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CharacterScreen extends State<CharacterScreenStatefulWidget> {
  final List<TextEditingController> playerNames = new List();
  @override
  void initState() {
    super.initState();
    playerNames.add(new TextEditingController());
    playerNames.add(new TextEditingController());
  }

  void _addNewPlayer() {
    playerNames.add(new TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Setup'),
          leading: new Container(),
        ),
        body: new Center(
            child: new Column(children: <Widget>[
          new Expanded(
            child: ListView.builder(
                itemCount: playerNames.length,
                itemBuilder: (context, index) {
                  final item = index.toString();

                  return Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify Widgets.
                      key: Key(item),
                      // We also need to provide a function that tells our app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        // Remove the item from our data source.
                        setState(() {
                          playerNames.removeAt(index);
                        });

                        // Then show a snackbar!
                        Scaffold.of(context)
                            //TODO create unremove element
                            .showSnackBar(SnackBar(
                                content: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                              new Text(playerNames[index].text != ""
                                  ? playerNames[index].text + " dismissed"
                                  : "Player " +
                                      index.toString() +
                                      " dismissed"),
                              new FlatButton(
                                child: new Text("Undo"),
                                onPressed: () {
                                  playerNames.insert(index, playerNames[index]);
                                },
                              )
                            ])));
                      },
                      // Show a red background as the item is swiped away
                      background: Container(color: Colors.red),
                      child: ListTile(title: TextField()));
                }),
          ),
        ])),
        floatingActionButton: new FloatingActionButton(
            onPressed: _addNewPlayer,
            tooltip: 'Add Player',
            child: new Icon(Icons.add)));
  }
}

class CharacterScreenStatefulWidget extends StatefulWidget {
  @override
  CharacterScreen createState() => new CharacterScreen();
}
