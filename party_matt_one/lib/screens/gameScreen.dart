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
  @override
  void initState() {
    questions.shuffle();
    for (var playerName in names) {
      playerNamesRandomOrder.add(playerName);
    }
    playerNamesRandomOrder.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Game'),
          leading: new Container(),
        ),
        body: new Center(
            child: screenShowing == 1
                ? Column(
                    children: <Widget>[
                      new Text(questions[questionIndex]),
                      new GridView.count(
                          crossAxisCount: names.length > 3 ? 2 : 1,
                          children: List.generate(names.length,
                              (index) {
                            return new RaisedButton(
                              onPressed: () {
                                nameChosen(index);
                              },
                              child: new Text(playerNamesRandomOrder[index]),
                            );
                          }))
                    ],
                  )
                : 
                //the page for showing pass to other player and wait until done
                screenShowing == 0
                    ? new Column(
                        children: [
                          new Text("Pass to"),
                          new Text(names[playersAnswered]),
                          new FlatButton(
                            child: new Text("Done"),
                            onPressed: () {
                              passed();
                            },
                          )
                        ],
                      )
                    : 
                    //the page for showing who won the question
                    FlatButton(child: new Text("Done with question..."),onPressed: (){
                      beginNextQuestion();
                    },)
            //shows the graph
            ));
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
    questionIndex+=1;
    for(var pointsByRound in playerPointsThisRound){
      pointsByRound=0;
    }
    setState(() {
          screenShowing=0;
        });
  }

  void showWinner() {
    //todo create graph and have page where they can move on
    setState(() {
          screenShowing=2;

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
}

class GameScreenStatefulWidget extends StatefulWidget {
  GameScreenStatefulWidget({this.names});
  final List names;
  @override
  GameScreen createState() => new GameScreen(names: names);
}
