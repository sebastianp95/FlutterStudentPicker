import 'package:flutter/material.dart';
import 'student.dart';
import 'storage.dart';

class AddNameRoute extends StatefulWidget {
  AddNameRoute({Key key, this.title}) : super(key: key);

  static const String routeName = "/AddNameRoute";

  final String title;


  @override
  _AddNameRouteState createState() => new _AddNameRouteState();

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(Icons.close, color: Colors.white),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        title: Text("Add Student Name"),
//        actions: <Widget>[
//          FlatButton(
//            onPressed: () {
//              /*...*/
//            },
//            child: Text(
//              "Add",
//              style: TextStyle(color: Colors.white),
//            ),
//          ),
//        ],
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            TextField(),
//          ],
//        ),
//      ),
//    );
//  }
}

class _AddNameRouteState extends State<AddNameRoute> {
  bool _canSave = false;
  Student _data = new Student.empty();
  List<Student> _items;

  void _setCanSave(bool save) {
    if (save != _canSave)
      setState(() => _canSave = save);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
          title: const Text('Add New Item'),
          actions: <Widget> [
            new FlatButton(
                child: new Text('ADD', style: theme.textTheme.body1.copyWith(color: _canSave ? Colors.white : new Color.fromRGBO(255, 255, 255, 0.5))),
                onPressed: _canSave ? () {
                  Storage storage =  Storage();
//                  storage.writeStudents(_items);
                  storage.readStudents();
                  Navigator.of(context).pop(_data); } : null
            )
          ]
      ),
      body: new Form(
        child: new ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          children: <Widget>[
            new TextField(
              decoration: const InputDecoration(
                labelText: "Enter name",
              ),
              onChanged: (String value) {
                _data.name = value;
                _setCanSave(value.isNotEmpty);
              },
            )
          ].toList(),
        ),
      ),
    );
  }
}