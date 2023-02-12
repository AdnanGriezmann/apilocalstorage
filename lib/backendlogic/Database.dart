import 'dart:io';

import 'package:apilocalstorage/models/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    
    return _database ??= await initDB();
  }

  
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'employee_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Employee('
          'userId INTEGER,'
          'id INTEGER PRIMARY KEY,'
          'title TEXT,'
          'body TEXT'
          
          ')');
    });
  }

  
  createdata(Employee newEmployee) async {
    await deleteAlldata();
    final db = await database;
    final res = await db.insert('Employee', newEmployee.toJson());

    return res;
  }

  
  Future<int> deleteAlldata() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Employee');

    return res;
  }

  Future<List<Employee>> getAlldata() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM EMPLOYEE");

    List<Employee> list =
        res.isNotEmpty ? res.map((c) => Employee.fromJson(c)).toList() : [];

    return list;
  }
}
