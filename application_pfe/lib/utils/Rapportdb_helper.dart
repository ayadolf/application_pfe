import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:application_pfe/models/Rapport.dart';

class Rapportdb_helper {
  static late Rapportdb_helper _rapportdb_helper;
  static late Database _database;
  String rapportTable = 'Rapport';
  String colId ='Id';
  String colPeriode = 'periode';

  Rapportdb_helper._createInstance();
  factory Rapportdb_helper() {
    if (_rapportdb_helper == null) {
      _rapportdb_helper = Rapportdb_helper._createInstance();
    }
    return _rapportdb_helper;
  }
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'rapport.db';

    var rapportDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return rapportDatabase;
  }
  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE $rapportTable(
        $colId INTEGER PRIMARY KEY,
        $colPeriode TEXT)
      ''');
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  ///crud

  // Show all rapport objects from the database
  Future<List<Map<String, dynamic>>> getRapport() async {
    Database db = await this.database;
    var result = await db.query(rapportTable, orderBy: '$colId ASC');
    return result;
  }

  // Insert a rapport object into the database
  Future<int> insertRechargeTele(Rapport rapport) async {
    Database db = await this.database;
    var result = await db.insert(rapportTable, rapport.tomap());
    return result;
  }

  // Update a rapport object and save it to the database
  Future<int> updateRechargeTele(Rapport rapport) async {
    Database db = await this.database;
    var result = await db.update(
      rapportTable,
      rapport.tomap(),
      where: '$colId = ?',
      whereArgs: [rapport.idR],
    );
    return result;
  }

  // Delete a rapport object from the database
  Future<int> deleteRechargeTele(int id) async {
    Database db = await this.database;
    var result = await db.delete(
      rapportTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
