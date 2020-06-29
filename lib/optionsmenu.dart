class Choice {
  const Choice({this.title});
  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Send/Receive'),
  const Choice(title: 'Add Name'),
  const Choice(title: 'Sort'),
  const Choice(title: 'Shuffle'),
  const Choice(title: 'Clear'),
  const Choice(title: 'About'),
];