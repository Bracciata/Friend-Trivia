import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'gameScreen.dart';

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  final Animation<int> animation;
  @override
  Widget build(BuildContext context) {
    return new Text(animation.value.toString(),
        style: new TextStyle(fontSize: 150.0));
  }
}
class NameTextField extends Container{
@override
Widget build(BuildContext context){
  return new Container();
}

}
class CharacterScreen extends State<CharacterScreenStatefulWidget>
    with TickerProviderStateMixin {
  final List<int> playerNameAllowed = new List();
  final List<TextEditingController> playerNames = new List();
  final List<int> textLength = new List();
  List<FocusNode> focusNodes = new List();
  String lastDeletedValue = "";
  int lastDeletedAllowed = -1;
  int dismissIndex = 0;
  bool visible = false;
  AnimationController aniController;
  static const int startValue = 4;
  bool allPlayersAllowed = false;

  @override
  void initState() {
    super.initState();
    playerNames.add(new TextEditingController());
    playerNames.add(new TextEditingController());
    textLength.add(0);
    textLength.add(0);
    //0 means untouched, 1 allowed, 2 not allowed
    playerNameAllowed.add(0);
    playerNameAllowed.add(0);

    aniController = new AnimationController(
        vsync: this, duration: new Duration(seconds: startValue));
  }

  void _focusChanged(int index) {
    if (focusNodes[index].hasFocus == false) {
      _checkIfThisNameAllowed(index, true);
    }
  }

  void _addNewPlayer() {
    if (playerNames.length < 9) {
      setState(() {
        playerNames.add(new TextEditingController());
        textLength.add(0);
        playerNameAllowed.add(0);
        _checkIfThisNameAllowed(playerNames.length-1, false);
      });
    } else {
      //todo implement warn user that max players is nine
    }
  }

  List<String> namesAsStringList(List<TextEditingController> list) {
    List<String> listNames = new List();
    for (var names in list) {
      listNames.add(names.text);
    }
    return listNames;
  }

  void _startCountdown() {
    setState(() {
      visible = true;
      aniController.forward(from: 0.0);
    });
  }

  void beginGame() {
    List<String> names = new List();
    for (final name in playerNames) {
      names.add(name.text);
    }
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                new GameScreenStatefulWidget(names: names)),
        (Route<dynamic> route) {
      return false;
    });
  }

  void cancelCountdown() {
    setState(() {
      aniController.stop();
      visible = false;
    });
  }

  void _checkIfAllPlayersAllowed() {
    if (playerNameAllowed.contains(0) || playerNameAllowed.contains(2)) {
      setState(() {
        allPlayersAllowed = false;
      });
    } else {
      setState(() {
        allPlayersAllowed = true;
      });
    }
  }

  void _checkIfThisNameAllowed(int index, bool colorCheck) {
    setState(() {
      playerNameAllowed[index] = 2;
      if (playerNames[index].text.length > 0) {
        List<String> l = namesAsStringList(playerNames);
        l.removeAt(index);
        if (!l.contains(playerNames[index].text)) {
          playerNameAllowed[index] = 1;
        }
      }
      _checkIfAllPlayersAllowed();
      if (colorCheck) {}
    });
  }

  void updateColor(int index) {}
  @override
  Widget build(BuildContext context) {
    focusNodes = new List();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Setup'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          FlatButton(
            child: new Text(
              "Begin Game",
              style: allPlayersAllowed
                  ? new TextStyle(color: Colors.white)
                  : new TextStyle(color: Colors.grey),
            ),
            onPressed:
                !visible ? (allPlayersAllowed ? _startCountdown : null) : null,
            //begin countdown to start game
          )
        ],
      ),
      body: new Center(
        child: new Stack(children: [
          new Column(children: <Widget>[
            new Expanded(
              child: ListView.builder(
                  itemCount: playerNames.length,
                  itemBuilder: (context, index) {
                    final item = index.toString();
                    focusNodes.add(new FocusNode());
                    focusNodes[index].addListener(() => _focusChanged(index));
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
                            lastDeletedAllowed = playerNameAllowed[index];
                            setState(() {
                              playerNames.removeAt(index);
                              textLength.removeAt(index);
                              playerNameAllowed.removeAt(index);
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
                                    textLength.insert(dismissIndex - 1,
                                        lastDeletedValue.length);
                                    playerNameAllowed.insert(
                                        dismissIndex - 1, lastDeletedAllowed);
                                  },
                                )));
                          },
                          // Show a red background as the item is swiped away
                          background: Container(color: Colors.red),
                          child: new Container(
                              decoration:
                                  new BoxDecoration(color: Colors.white),
                              child: ListTile(
                                  title: TextField(
                                      controller: playerNames[index],
                                      maxLength: 19,
                                      onChanged: (text) {
                                        setState(() {
                                          textLength[index] = text.length;
                                        });
                                        _checkIfThisNameAllowed(index, false);
                                      },
                                      focusNode: focusNodes[index],
                                      onEditingComplete: () {
                                        _checkIfThisNameAllowed(index, true);
                                      },
                                      decoration: new InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          counterText: (18 - textLength[index])
                                              .toString(),
                                          //TODO decide between allowing the user to go as long as they want and just tell them they are wrong or using max length.
                                          counterStyle: (18 -
                                                      textLength[index] <
                                                  0)
                                              ? new TextStyle(color: Colors.red)
                                              : null)))));
                    } else {
                      return Container(
                          decoration: new BoxDecoration(
                              color: Color.fromARGB(255, 221, 221, 221)),
                          child: ListTile(
                              title: TextField(
                                  controller: playerNames[index],
                                  maxLength: 18,
                                  onChanged: (text) {
                                    setState(() {
                                      textLength[index] = text.length;
                                    });
                                    _checkIfThisNameAllowed(index, false);
                                  },
                                  focusNode: focusNodes[index],
                                  onEditingComplete: () {
                                    _checkIfThisNameAllowed(index, true);
                                  },
                                  decoration: new InputDecoration(
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 221, 221, 221),
                                    counterText:
                                        (18 - textLength[index]).toString(),
                                  ))));
                    }
                  }),
            ),
          ]),
          visible
              ? new Stack(
                  fit: StackFit.expand,
                  alignment: AlignmentDirectional.center,
                  children: [
                      new Positioned.fill(
                          child: new Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: new BoxDecoration(
                                  color: Color.fromARGB(123, 0, 0, 0)))),
                      new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Countdown(
                              animation: new StepTween(
                                      begin: startValue, end: 0)
                                  .animate(aniController)
                                    ..addStatusListener((state) {
                                      if (state == AnimationStatus.completed) {
                                        beginGame();
                                      }
                                    }),
                            ),
                            new FlatButton(
                              child: new Text("Cancel"),
                              onPressed: () {
                                cancelCountdown();
                              },
                            )
                          ]),
                    ])
              : new Container()
        ]),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: !visible ? _addNewPlayer : null,
          tooltip: 'Add Player',
          backgroundColor: playerNames.length < 9
              ? (visible
                  ? Color.alphaBlend(
                      Color.fromARGB(123, 0, 0, 0), ThemeData().accentColor)
                  : null)
              : visible
                  ? Color.alphaBlend(Color.fromARGB(123, 0, 0, 0),
                      Color.fromARGB(255, 221, 221, 221))
                  : Color.fromARGB(255, 221, 221, 221),
          child: new Icon(Icons.add)),
    );
  }
//todo show which names are not allowed
////maybe make color red
//todo share why names is not allowed
////If allow over max length then explain it is over max length
////Otherwise notify can't be blank
////Also make sure no others share name
//TODO still can't remove any element other than last in list, that is bad.
//TODO if they press non ready begin button show them what is wrong
//TODO implement color change when checke with true for check color.
//TODO stop violating dry and clean up build
}

class CharacterScreenStatefulWidget extends StatefulWidget {
  @override
  CharacterScreen createState() => new CharacterScreen();
}
