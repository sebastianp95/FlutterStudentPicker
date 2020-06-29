import 'package:flutter/material.dart';

class AboutRoute extends StatelessWidget {
  final AssetImage _bbuilding = new AssetImage("assets/bbuildingwavy.jpg");
  final AssetImage _headspace = new AssetImage("assets/headspace.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Second Route"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(image: _bbuilding),
            SizedBox(height: 50),
            Text('ITEC 4550', style: Theme.of(context).textTheme.title),
            SizedBox(height: 50),
            Image(image: _headspace),
            SizedBox(height: 50),
            Text('April 21/2020 \nSebastian Perez', style:Theme.of(context).textTheme.title),
//            RaisedButton(
//              onPressed: () {
//                Navigator.pop(context);
//              },
//              child: Text('Go back!'),
//            ),
          ],
        ),
      ),
    );
  }
}
