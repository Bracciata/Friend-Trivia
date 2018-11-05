import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CharacterScreen extends State<CharacterScreenStatefulWidget> {
  final List<TextEditingController> playerNames = new List();
  String lastDeletedValue = "";
  int dismissIndex = 0;
  @override
  void initState() {
    super.initState();
    playerNames.add(new TextEditingController());
    playerNames.add(new TextEditingController());
  }

  void _addNewPlayer() {
    setState(() {
      playerNames.add(new TextEditingController());
    });
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
                        dismissIndex = index+1;
                        lastDeletedValue = playerNames[index].text;
                        playerNames[index].text = "";

                        setState(() {
                          playerNames.removeAt(index);

                        });

                        // Then show a snackbar!
                        Scaffold.of(context)
                              .showSnackBar(SnackBar(
                                content: new Text(lastDeletedValue != ""
                                    ? lastDeletedValue + " dismissed"
                                    : "Player " +
                                        (dismissIndex).toString() +
                                        " dismissed"),
                                action: new SnackBarAction(
                                  label: "Undo",
                                  onPressed: () {
                                    setState(() {
                                      playerNames.insert(
                                          dismissIndex-1,
                                          new TextEditingController(
                                              text: lastDeletedValue));
                                    });
                                  },
                                )));
                      },
                      // Show a red background as the item is swiped away
                      background: Container(color: Colors.red),
                      child: ListTile(title: TextField(controller: playerNames[index],)));
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
