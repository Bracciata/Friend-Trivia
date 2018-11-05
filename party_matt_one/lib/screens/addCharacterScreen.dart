import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CharacterScreen extends State<AddCharacterStatefulWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<int> _list;
  static List<TextEditingController> names = new List();
  int _selectedItem;
  int _nextItem; // The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
    names.add(new TextEditingController());
    names.add(new TextEditingController());
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 2;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
          //removes character when selected
          _remove();
        });
      },
    );
  }

  // Used to build an item after it has been removed from the list. This method is
  // needed because a removed item remains  visible until its animation has
  // completed (even though it's gone as far this ListModel is concerned).
  // The widget will be used by the [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(
      int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    _list.insert(_list.length, _nextItem++);
    names.add(new TextEditingController());
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem));
      slideNames(_selectedItem);
      setState(() {
        _selectedItem = null;
      });
    }
  }

  void slideNames(int selection) {
    names.removeAt(selection);
    if (selection < _list.length) {
      names.elementAt(selection).value = names.elementAt(selection + 1).value;
      slideNames(selection++);
    } else {
      names.removeAt(selection);
    }
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
            child: new AnimatedList(
              key: _listKey,
              initialItemCount: _list.length,
              itemBuilder: _buildItem,
            ),
          ),
          new Expanded(
            child: new Align(
              alignment: FractionalOffset.bottomCenter,
              child: new Text('Begin'),
            ),
          ),
        ])),
        floatingActionButton: new FloatingActionButton(
            onPressed: _insert,
            tooltip: 'Add Player',
            child: new Icon(Icons.add)));
  }
}

class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatelessWidget {
  const CardItem(
      {Key key,
      @required this.animation,
      this.onTap,
      @required this.item,
      this.selected: false})
      : assert(animation != null),
        assert(item != null && item >= 0),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final int item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: SizedBox(
          height: 128.0, //TODO replace this with calculateAllowedHeight();
            child: Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify Widgets.
              key: Key("index"),
              // We also need to provide a function that tells our app
              // what to do after an item has been swiped away.
              onDismissed: (direction) {
                // Remove the item from our data source.
                onTap();

                // Then show a snackbar!
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$item dismissed")));
              },
              // Show a red background as the item is swiped away
              background: Container(color: Colors.red),
            child: Card(
              color: Colors.primaries[item % Colors.primaries.length],

              child: ListTile(
                leading: TextField(
                  controller: CharacterScreen.names[item],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  //TODO add on submitted to check no other users of same name
                  //TODO add characters remaining counter
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double calculateAllowedHeight() {
    //TODO implement this so max of 9 players
    return 0.0;
  }
}

class AddCharacterStatefulWidget extends StatefulWidget {
  @override
  CharacterScreen createState() => new CharacterScreen();
}
