import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model.dart';

class DatabaseDb {
  static final DatabaseDb instance = DatabaseDb._instance();

  static Database? _db = null;
  DatabaseDb._instance();

  String tableName = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'catat.db';
    final catatDB =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return catatDB;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getDataaMapList() async {
    Database? db = await this.db;

    final List<Map<String, dynamic>> result = await db!.query(tableName);
    return result;
  }

  Future<List<Dataa>> getDataaList() async {
    final List<Map<String, dynamic>> noteMapList = await getDataaMapList();

    final List<Dataa> dataaList = [];

    noteMapList.forEach((noteMap) {
      dataaList.add(Dataa.fromMap(noteMap));
    });
    dataaList.sort((noteA, noteB) => noteA.date!.compareTo(noteB.date!));

    return dataaList;
  }

  Future<int> insertDataa(Dataa dataa) async {
    Database? db = await this.db;
    final int result = await db!.insert(
      tableName,
      dataa.toMap(),
    );
    return result;
  }

  Future<int> updateDataa(Dataa dataa) async {
    Database? db = await this.db;
    final int result = await db!.update(
      tableName,
      dataa.toMap(),
      where: '$colId = ?',
      whereArgs: [dataa.id],
    );
    return result;
  }

  Future<int> deleteDataa(int id) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}