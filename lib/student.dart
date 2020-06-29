class Student {
  String _name;
  bool _hidden;
  Student(this._name, this._hidden);

  Student.empty() {
    _name = "";
    _hidden = true;
  }

  String get name => _name;

  bool get hidden => _hidden;


  set name(String newTitle) {
    if (newTitle.length <= 255) {
      this._name = newTitle;
    }
  }

  set hidden(bool b) {

      this._hidden = b;

  }
  bool toBoolean(String str, [bool strict]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
     map['name'] = _name;
    map['hidden'] = _hidden.toString();

    return map;
  }

  // Extract a Note object from a Map object
  Student.fromMapObject(Map<String, dynamic> map) {
    print("map:  \nname "+map['name']+
        "\nhidden:  "+map['hidden'].toString()
    );
    this._name = map['name'];
    this._hidden = toBoolean(map['hidden']);

  }
}