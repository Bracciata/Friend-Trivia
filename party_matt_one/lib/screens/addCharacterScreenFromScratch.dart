import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CharacterScreen extends State<CharacterScreenStatefulWidget> {
  final List<TextEditingController> playerNames = new List();
  final List<int> textLength = new List();
  String lastDeletedValue = "";
  int dismissIndex = 0;
  @override
  void initState() {
    super.initState();
    playerNames.add(new TextEditingController());
    playerNames.add(new TextEditingController());
    textLength.add(0);
    textLength.add(0);
  }

  void _addNewPlayer() {
    setState(() {
      playerNames.add(new TextEditingController());
      textLength.add(0);
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
                  if (index > 1) {
                    return Dismissible(
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify Widgets.
                        key: Key(item),
                        // We also need to provide a function that tells our app
                        // what to do after an item has been swiped away.
                        onDismissed: (direction) {
                          // Remove the item from our data source.
                          dismissIndex = index + 1;
                          lastDeletedValue = playerNames[index].text;
                          playerNames[index].text = "";

                          setState(() {
                            playerNames.removeAt(index);
                            textLength.removeAt(index);
                          });

                          // Then show a snackbar!
                          Scaffold.of(context).showSnackBar(SnackBar(
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
                                        dismissIndex - 1,
                                        new TextEditingController(
                                            text: lastDeletedValue));
                                  });
                                },
                              )));
                        },
                        // Show a red background as the item is swiped away
                        background: Container(color: Colors.red),
                        child: new Container(decoration: new BoxDecoration(color: Colors.white), child:ListTile(
                          
                            title: TextField(
                                controller: playerNames[index],
                                maxLength: 19,
                                onChanged: (text) {
                                  setState(() {
                                    textLength[index] = text.length;
                                  });
                                },
                                
                                decoration: new InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    counterText:
                                        (18 - textLength[index]).toString(),
                                        //TODO decide between allowing the user to go as long as they want and just tell them they are wrong or using max length.
                                    counterStyle: (18 - textLength[index] < 0)
                                        ? new TextStyle(color: Colors.red)
                                        : null)))));
                    } else {
                    return Container(decoration: new BoxDecoration(color: Color.fromARGB(255, 221,221, 221)), child: ListTile(
                        title: TextField(
                            controller: playerNames[index],
                            maxLength: 18,
                            onChanged: (text) {
                              setState(() {
                                textLength[index] = text.length;
                              });
                            },
                            decoration: new InputDecoration(
                              filled: true,
                              fillColor:Color.fromARGB(255, 221,221, 221),
                              counterText: (18 - textLength[index]).toString(),
                            ))));
                  }
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
