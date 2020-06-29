import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:studentpicker/student.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String nameTable = 'note_table';
  String colName = 'name';
  String colHidden = 'hidden';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'students.db';

    // Open/create the database at a given path
    var studentDB = await openDatabase(path, version: 1, onCreate: _createDb);
    return studentDB;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $nameTable($colName TEXT, '
        '$colHidden TEXT);');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $nameTable ;');
    print("Query * ");
    print(result);
//    var result = await db.query(nameTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertStudent(Student student) async {
    Database db = await this.database;
    var result = await db.insert(nameTable, student.toMap());
    return result;
  }

  // Delete Operation: Delete a Note object from database
//  Future<int> deleteNote(int id) async {
//    var db = await this.database;
//    int result = await db.rawDelete('DELETE FROM $nameTable;');
//    return result;
//  }
  // Update Operation: Update a Note object and save it to database
//  Future<int> updateNote(Student student) async {
//    var db = await this.database;
//    var result = await db.update(nameTable, student.toMap(), where: '$colId = ?', whereArgs: [student.id]);
//    return result;
//  }
//  // Get number of Note objects in database
//  Future<int> getCount() async {
//    Database db = await this.database;
//    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $nameTable');
//    int result = Sqflite.firstIntValue(x);
//    return result;
//  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Student>> getStudentList() async {
//    Database db = await this.database;
//    await db.rawQuery('DELETE FROM $nameTable ;');

    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Student> noteList = List<Student>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Student.fromMapObject(noteMapList[i]));
    }
    print("getStudentslist");
    print(noteList);
    return noteList;
  }

  void insertStudentList(List<Student> l) async {
    Database db = await this.database;

    await db.rawQuery('DELETE FROM $nameTable ;');

    for (int i = 0; i < l.length; i++) {
      insertStudent(l[i]);
    }
    print("Helllooooooo?");
  }
}
