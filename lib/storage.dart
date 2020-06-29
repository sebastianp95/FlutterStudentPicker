// thanks -	https://flutter.io/docs/cookbook/persistence/reading-writing-files

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'student.dart';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
//    print('$path/names.txt');
    return File('$path/names.txt');
  }

  Future<List<Student>> readStudents() async {
    List<Student> names;
    try {
      final file = await _localFile;
      names = List<Student>();
      await file.readAsLines().then((List<String> lines) {
        for (int i = 0; i < lines.length; i++) {
          List<String> tokens = lines[i].split(',');
          bool vis = tokens[1] == 'true' ? true : false;
          names.add(new Student(tokens[0], vis));
        }
      });
      // Read the file
    } catch (e) {
      print('Whoa Nellie: ' + e.toString());
      return null;
    }
    return names;
  }

  Future<File> writeStudents(List<Student> names) async {

    final file = await _localFile;  // Write the file
    var sink = file.openWrite(mode: FileMode.write);
    for (int i = 0; i < names.length; i++) {
      var line = names[i].name + ',' + (names[i].hidden ? 'true' : 'false') +
          '\n';
      sink.write(line);
    }
    await sink.flush();
    await sink.close();

    return file;
  }
  Future<File> cleanFileStudents() async {

    final file = await _localFile;  // Write the file
    var sink = file.openWrite(mode: FileMode.write);

    sink.flush();
    print(file.toString());

    file.delete();
    print(file.toString());


    await sink.flush();
    await sink.close();

    return file;
  }
}