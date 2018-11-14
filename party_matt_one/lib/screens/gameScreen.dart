import 'package:flutter/material.dart';
import 'package:party_matt_one/strings/questions.dart';

//TODO is begin game using players names
//TODO create the questions
class GameScreen extends State<GameScreenStatefulWidget> {
  List names;
  GameScreen({this.names});
  List questions = QuestionStrings.pollsQuestions;
  List playerNamesRandomOrder = new List();
  int questionIndex = 0;
  List playerPointsThisRound;
  List playerPointsTotal;
  //0 is pass to player, 1 is select, 2 is question over graph
  int screenShowing = 0;
  int playersAnswered = 0;
  int remainingHeight = 0;
  int maxSingleColumnPlayers = 3;
  @override
  void initState() {
    questions.shuffle();
    playerPointsThisRound = new List();
    playerPointsTotal = new List();
    for (var playerName in names) {
      playerNamesRandomOrder.add(playerName);
      playerPointsThisRound.add(0);
      playerPointsTotal.add(0);
    }
    playerNamesRandomOrder.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //removes tool bar, removes notification bar with 24, removes textfield
    double itemHeight =
        (size.height - kToolbarHeight - 24) - (size.height / 10);
    names.length > maxSingleColumnPlayers
        ? itemHeight = itemHeight / ((names.length / 2).ceil())
        : itemHeight = itemHeight / names.length;
    double itemWidth = (size.width);
    names.length > maxSingleColumnPlayers
        ? itemWidth = itemWidth / 2
        : itemWidth = itemWidth;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Game'),
          leading: new Container(),
        ),
        body: new Center(
            child: screenShowing == 1
                ? Column(
                    children: <Widget>[
                      new SizedBox(
                          height: size.height / 10,
                          child: new Text(questions[questionIndex])),
                      new Expanded(
                        child: new GridView.count(
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisCount:
                                names.length > maxSingleColumnPlayers ? 2 : 1,
                            children: List.generate(names.length, (index) {
                              return new GestureDetector(
                                  key: Key(index.toString()),
                                  onTap: () {
                                    nameChosen(index);
                                  },
                                  child: new Card(
                                    color: Colors.primaries[
                                        index % Colors.primaries.length],
                                    child: Center(
                                        child: new Text(
                                            playerNamesRandomOrder[index])),
                                  ));
                            })),
                      )
                    ],
                  )
                :
                //the page for showing pass to other player and wait until done
                screenShowing == 0
                    ? GestureDetector(
                        child: new Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              new Text(
                                "Pass to",
                                textAlign: TextAlign.center,
                              ),
                              new Text(names[playersAnswered],
                                  textAlign: TextAlign.center),
                              new FlatButton(
                                child: new Text("Done"),
                                onPressed: () {
                                  passed();
                                },
                              )
                            ],
                          ),
                          color: Colors.white,
                        ),
                        onTap: passed,
                      )
                    :
                    //the page for showing who won the question
                    GestureDetector(
                        child: new Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                FlatButton(
                                  child: new Text("Done with question..."),
                                  onPressed: () {
                                    beginNextQuestion();
                                  },
                                )
                              ]),
                          color: Colors.white,
                        ),
                        onTap: beginNextQuestion)));
  }

  void nameChosen(int index) {
    //Either pass the phone to next person or pass to person of name
    addPoints(index);
    playerNamesRandomOrder.shuffle();
    playersAnswered += 1;
    //countdown to pass to next player or next question by showing winner
    if (playersAnswered == names.length) {
      showWinner();
    } else {
      passToNextPlayer();
    }
  }

  void beginNextQuestion() {
    //TODO implement out of questions or done with game
    playersAnswered = 0;
    questionIndex += 1;
    for (var pointsByRound in playerPointsThisRound) {
      pointsByRound = 0;
    }
    setState(() {
      screenShowing = 0;
    });
  }

  void showWinner() {
    //todo create graph and have page where they can move on
    setState(() {
      screenShowing = 2;
    });
  }

  void addPoints(int index) {
    int indexOfNames = names.indexOf(playerNamesRandomOrder[index]);
    playerPointsTotal[indexOfNames] += 1;
    playerPointsThisRound[indexOfNames] += 1;
  }

  void passed() {
    setState(() {
      screenShowing = 1;
    });
  }

  void passToNextPlayer() {
    //show pass to next player and let them click when ready
    setState(() {
      screenShowing = 0;
    });
  }
  //pass to play feature is randomize where name is in list so you can't guess what others have chosen
  //TODO exclude yourself from the list
}

class GameScreenStatefulWidget extends StatefulWidget {
  GameScreenStatefulWidget({this.names});
  final List names;
  @override
  GameScreen createState() => new GameScreen(names: names);
}
