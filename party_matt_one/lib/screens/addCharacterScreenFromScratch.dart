import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'gameScreen.dart';

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;
  @override
  Widget build(BuildContext context) {
    return new Text(animation.value.toString(),
        style: new TextStyle(fontSize: 150.0));
  }
}

class CharacterScreen extends State<CharacterScreenStatefulWidget>
    with TickerProviderStateMixin {
  final List<TextEditingController> playerNames = new List();
  final List<int> textLength = new List();
  String lastDeletedValue = "";
  int dismissIndex = 0;
  bool visible = false;
  AnimationController aniController;
  static const int startValue = 4;
  @override
  void initState() {
    super.initState();
    playerNames.add(new TextEditingController());
    playerNames.add(new TextEditingController());
    textLength.add(0);
    textLength.add(0);
    aniController = new AnimationController(
        vsync: this, duration: new Duration(seconds: startValue));
  }

  void _addNewPlayer() {
    if (playerNames.length < 9) {
      setState(() {
        playerNames.add(new TextEditingController());
        textLength.add(0);
      });
    } else {
      //todo implement warn user that max players is nine
    }
  }

  void startCountdown() {
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
                new GameScreenStatefulWidget(names: names)),(Route<dynamic>  route){
                  return false;
                });
  }

  void cancelCountdown() {
    setState(() {
      aniController.stop();
      visible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Setup'),
          leading: new IconButton(icon:new Icon(Icons.arrow_back),onPressed: ()=>Navigator.pop(context),),
          actions: <Widget>[
            FlatButton(
              child: new Text("Begin Game",style: new TextStyle(color: Colors.white),),
              onPressed: () {
                //begin countdown to start game
                startCountdown();
              },
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
                                      textLength.insert(dismissIndex - 1,
                                          lastDeletedValue.length);
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
                                        },
                                        decoration: new InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            counterText: (18 -
                                                    textLength[index])
                                                .toString(),
                                            //TODO decide between allowing the user to go as long as they want and just tell them they are wrong or using max length.
                                            counterStyle:
                                                (18 - textLength[index] < 0)
                                                    ? new TextStyle(
                                                        color: Colors.red)
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
                                animation:
                                    new StepTween(begin: startValue, end: 0)
                                        .animate(aniController)
                                          ..addStatusListener((state) {
                                            if (state ==
                                                AnimationStatus.completed) {
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
        floatingActionButton: new Stack( children:[FloatingActionButton(
            onPressed: !visible?_addNewPlayer:null,
            tooltip: 'Add Player',
            backgroundColor: playerNames.length < 9
                ? null
                : Color.fromARGB(255, 221, 221, 221),
            child: new Icon(Icons.add)),
              visible ? new Positioned.fill(
                            child: new Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: new BoxDecoration(
                                    color: Color.fromARGB(123, 0, 0, 0),shape: BoxShape.circle))):new Positioned.fill(
                            child: new Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: new BoxDecoration(
                                    color: Color.fromARGB(0, 0, 0, 0),shape: BoxShape.circle))),
            ]));
            }
  //todo add a check if player name is allowed
  //todo check if all players have names
  //todo implement begin game when countdown ends
  //todo make it so you can't press begin multiple times
  void _checkIfAllPlayersAllowed(){

  }
}


class CharacterScreenStatefulWidget extends StatefulWidget {
  @override
  CharacterScreen createState() => new CharacterScreen();
}
