import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentpicker/add_name.dart';
import 'package:studentpicker/send_receive.dart';
import 'package:studentpicker/utils/database_helper.dart';
import 'optionsmenu.dart';
import 'about.dart';
import 'student.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    MaterialColor createMaterialColor(Color color) {
      List strengths = <double>[.05];
      Map swatch = <int, Color>{};
      final int r = color.red, g = color.green, b = color.blue;

      for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
      strengths.forEach((strength) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      });
      return MaterialColor(color.value, swatch);
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        primarySwatch: createMaterialColor(Color(0xFF00B341)),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.

//        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'GGC Thorns, Roses and Buds',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below)

  // This class is the configuration for the state. It holds the values (in this
  // case the title)
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final AssetImage _bbuilding = new AssetImage("assets/bbuildingwavy.jpg");
  final AssetImage _rose = new AssetImage("assets/rose.png");
  final AssetImage _thorn = new AssetImage("assets/thorn.png");
  final AssetImage _bud = new AssetImage("assets/bud.png");
  AssetImage _asset;
  List<AssetImage> imageList = new List<AssetImage>();
  List<Student> _items;
  Future<List<Student>> students;
  DatabaseHelper databaseHelper = DatabaseHelper();
  int _position = -1;
  int _randomImage;
  AppLifecycleState appLifecycleState;
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_items == null) {
      _items = List<Student>();
      imageList.add(_rose);
      imageList.add(_thorn);
      imageList.add(_bud);
      _randomImage = -1;
      setState(() {
      updateListView();
    });
    }

//    _items.clear();
  }

  @override
  void dispose() {
    super.dispose();
    print("is this working? On dipose");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      databaseHelper.insertStudentList(_items);
      print("On Pause");
    } else if (state == AppLifecycleState.resumed) {
      print("On Resume");
    }
  }

  String img() {
    if (_randomImage == 0)
      return "assets/rose.png";
    else if (_randomImage == 1)
      return "assets/thorn.png";
    else if (_randomImage == 2) return "assets/bud.png";

    return "assets/transparent.png";
  }

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          // everything in overflow menu
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        GestureDetector(
          onTap: () {
            print('tapped!');
//                _openDialogAddItem();
            _populate();
          }, // handle your image tap here
          child: Image(image: _bbuilding),
        ),
        SizedBox(height: 20),
        Container(
          width: 260.0,
          height: 60,
          child: ListTile(
            title: Text(
              _position >= 0 ? _items[_position].name : '',
              style: TextStyle(fontSize: 35, color: Colors.green),
              textAlign: TextAlign.right,
            ),
            trailing: Image(image: AssetImage(img())), //call your method here
          ),
        ),
//        Text(_position >= 0 ? _items[_position].name : '',
//            style: TextStyle(fontSize: 35, color: Colors.green)),

        Expanded(
          child: ListView.separated(
            // Let the ListView know how many items it needs to build.
            itemCount: _items.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final item = _items[index].name;
              return Dismissible(
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
                key: Key(item),
                onDismissed: (direction) {
                  setState(() {
                    _items.removeAt(index);
                  });

                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("$item dismissed")));
                },
                child: ListTile(
                  title: Text(item,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8), fontSize: 25)),
                  trailing:
                      Icon(!_items[index].hidden ? Icons.visibility_off : null),
                  onTap: () {
                    if (!_items[index].hidden) {
                      _items[index].hidden = true;
                      print("Visibily for :" +
                          _items[index].name +
                          ", " +
                          _items[index].hidden.toString());

                      setState(() {
                        Icon(
                          Icons.visibility_off,
                        );
                      });
                    } else {
                      _items[index].hidden = false;
                      print("Visibily for :" +
                          _items[index].name +
                          ", " +
                          _items[index].hidden.toString());
                      setState(() {
                        Icon(
                          null,
                        );
                      });
                    }
                    print("tapped");
                  },
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _position = Random().nextInt(_items.length);
            _randomImage = new Random().nextInt(imageList.length);
            String item;
//            for (var i = 0; i < _items.length; i++) {
//              if(){
//                Scaffold
//                    .of(context)
//                    .showSnackBar(
//                    SnackBar(content: Text("no items selected")));
//              }
//            }
            while (!_items[_position].hidden) {
              _position = Random().nextInt(_items.length);
            }
            item = _items[_position].name;

            print("random position =" + item);
          });
        },
        child: Icon(Icons.sync),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getRow(int position) {
    return new FlatButton(
      child: new ListTile(
        title: new Text(_items[position].name),
//        trailing: new Text(_items[position].hidden.toString()),
      ),
      onPressed: () {
        setState(() {
          _items.removeAt(position);
        });
      },
    );
  }

  Future _populate() async {
    setState(() {
      _items.clear();
      _items.add(new Student("Graham", true));
      _items.add(new Student("Hill", true));
      _items.add(new Student("Manson", true));
      _items.add(new Student("Messi", false));
      _items.add(new Student("Lebron", false));
      _items.add(new Student("Alan", true));
//      Storage storage = new Storage();
//      storage.writeStudents(_items);
    });
  }

  Future _openDialogAddItem() async {
    Student data =
        await Navigator.of(context).push(new MaterialPageRoute<Student>(
            builder: (BuildContext context) {
              return new AddNameRoute();
            },
            fullscreenDialog: true));

    setState(() {
      print(data.name + " " + data.hidden.toString());
      _items.add(data);
    });
  }

  void _select(Choice choice) {
    setState(() {
      switch (choice.title) {
        case 'About':
          // do something
          print('selected about ...');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutRoute()),
          );
          break;
        case 'Send/Receive':
          print('selected SendReceive ...');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SendReceiveRoute()),
          );
          break;
        case 'Shuffle':
          print('selected shuffle ...');
          _items.shuffle();
          break;
        case 'Sort':
          print('selected sort ...');
          _items.sort((a, b) {
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
          break;
        case 'Clear':
          print('selected clear ...');
          if (_items.isEmpty) {
            print('Empty');
          }
          _items.clear();
          _randomImage = -1;
          _position = -1;
          break;
        case 'Add Name':
          // do something
          print('selected AddName ...');
          _openDialogAddItem();
          break;
      }
    });
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Student>> studentListFuture = databaseHelper.getStudentList();
      studentListFuture.then((studentList) {
        setState(() {
          this._items = studentList;
        });
      });
    });
  }
}
