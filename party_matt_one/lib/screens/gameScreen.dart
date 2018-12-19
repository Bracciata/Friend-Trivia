import 'package:flutter/material.dart';
import 'package:party_matt_one/strings/questions.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

class BetweenStatePage extends StatelessWidget {
  final Function pointGatheringFunction;
  final Function whatNextFunction;
  BetweenStatePage({this.pointGatheringFunction, this.whatNextFunction});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        child: new Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: SimpleBarChart(pointGatheringFunction())),
                FlatButton(
                  child: new Text("Done with question..."),
                  onPressed: () {
                    whatNextFunction();
                  },
                ),
              ]),
          color: Colors.white,
        ),
        onTap: whatNextFunction);
  }
}

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

//TODO create the questions

class GameScreen extends State<GameScreenStatefulWidget> {
  GameScreen({this.names});
  List names;
  List questions = QuestionStrings.pollsQuestions;
  List playerNamesRandomOrder = new List();
  int questionIndex = 0;
  //0 is pass to player, 1 is select, 2 is question over graph
  int screenShowing = 0;
  int playersAnswered = 0;
  int remainingHeight = 0;
  int maxSingleColumnPlayers = 3;
  int designatedNumberOfQuestions=10;
  List players;
  TextStyle nameCardTS = new TextStyle();
  @override
  void initState() {
    questions.shuffle();
    players = new List<Player>();
    for (var playerName in names) {
      players.add(new Player(playerName));
      playerNamesRandomOrder.add(playerName);
    }
    playerNamesRandomOrder.shuffle();
    nameCardTS = new TextStyle(color: Colors.white, fontSize: 30.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //removes tool bar, removes notification bar with 24, removes textfield
    double itemHeight =
        (size.height - kToolbarHeight - 24) - (size.height / 10);
    names.length - 1 > maxSingleColumnPlayers
        ? itemHeight = itemHeight / (((names.length - 1) / 2).ceil())
        : itemHeight = itemHeight / (names.length - 1);
    double itemWidth = (size.width);
    names.length - 1 > maxSingleColumnPlayers
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
                                names.length - 1 > maxSingleColumnPlayers
                                    ? 2
                                    : 1,
                            children: List.generate(names.length - 1, (index) {
                              return !playerNamesRandomOrder
                                      .getRange(0, index + 1)
                                      .contains(names[playersAnswered])
                                  ? new GestureDetector(
                                      key: Key(index.toString()),
                                      onTap: () {
                                        nameChosen(index);
                                      },
                                      child: new Card(
                                        color: Colors.primaries[
                                            index % Colors.primaries.length],
                                        child: Center(
                                            child: new Text(
                                          playerNamesRandomOrder[index],
                                          style: nameCardTS,
                                        )),
                                      ))
                                  : new GestureDetector(
                                      key: Key(index.toString()),
                                      onTap: () {
                                        nameChosen(index + 1);
                                      },
                                      child: new Card(
                                        color: Colors.primaries[
                                            index % Colors.primaries.length],
                                        child: Center(
                                            child: new Text(
                                          playerNamesRandomOrder[index + 1],
                                          style: nameCardTS,
                                        )),
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
                      //below checking if questions length is not nessecary because from here on out length will be long enough you won't want to answer all
                    : (questionIndex + 1 < questions.length)&&(questionIndex+1<designatedNumberOfQuestions)
                        ?
                        //the page for showing who won the question
                        new BetweenStatePage(
                            pointGatheringFunction: getEndRoundPoints,
                            whatNextFunction: beginNextQuestion)
                        : new BetweenStatePage(
                            pointGatheringFunction: getEndRoundPoints,
                            whatNextFunction: endGame)));
  }

  List<charts.Series<Player, String>> getEndRoundPoints() {
    return [
      new charts.Series<Player, String>(
        id: 'Points',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Player player, _) => player.name,
        measureFn: (Player player, _) => player.pointsThisRound,
        data: players,
      )
    ];
  }

  List<charts.Series<Player, String>> getEndGamePoints() {
    return [
      new charts.Series<Player, String>(
        id: 'Points',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Player player, _) => player.name,
        measureFn: (Player player, _) => player.pointsTotal,
        data: players,
      )
    ];
  }

  void endGame() {
    //Move to same players / new players screen
    //TODO implement end
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
    playersAnswered = 0;
    questionIndex += 1;
    for (int i = 0; i < players.length; ++i) {
      players.elementAt(i).endOfRound();
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
    players.elementAt(indexOfNames).choosen();
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
}

class GameScreenStatefulWidget extends StatefulWidget {
  GameScreenStatefulWidget({this.names});
  final List names;
  @override
  GameScreen createState() => new GameScreen(names: names);
}
