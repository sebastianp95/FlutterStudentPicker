import 'package:flutter/material.dart';

class SendReceiveRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: choicesList.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Send/Receive'),
            bottom: TabBar(
              isScrollable: false,
              tabs: choicesList.map((ChoiceSendReceive choice) {
                return Tab(
                  text: choice.title,
                  icon: Icon(choice.icon),
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: choicesList.map((ChoiceSendReceive choice) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ChoiceCard(choice: choice),
              );
            }).toList(),
          ),
        ),
      );
  }
}

class ChoiceSendReceive {
  const ChoiceSendReceive({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<ChoiceSendReceive> choicesList = const <ChoiceSendReceive>[
  const ChoiceSendReceive(title: 'Send', icon: Icons.arrow_upward),
  const ChoiceSendReceive(title: 'Receive', icon: Icons.arrow_downward),
//  const ChoiceSendReceive(title: 'BOAT', icon: Icons.directions_boat),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final ChoiceSendReceive choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.title;
    return Card(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
//            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title+"- Coming soon!", style: textStyle),
          ],
        ),
      ),
    );
  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("First Route"),
//      ),
//      body: Center(
//        child: RaisedButton(
//          onPressed: () {
//            Navigator.pop(context);
//          },
//          child: Text('Go back!'),
//        ),
//      ),
//    );
//  }
}