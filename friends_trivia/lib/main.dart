import 'package:flutter/material.dart';
import 'screens/addCharacterScreenFromScratch.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/screens/addCharacterScreenFromScratch': (BuildContext context) =>
            new CharacterScreenStatefulWidget(),
      },
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void beginGame() {
    setState(() {
      Navigator.pushNamed(context, '/screens/addCharacterScreenFromScratch');
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(

        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Pick, Pick, Pass"),
            new RaisedButton(
              onPressed: beginGame,
              child: new Text("Begin"),
            )
          ],
        ),
      ),
    );
  }
}
