import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/Defis.dart';

class Defisdb_helper {
  static Defisdb_helper? _defisdb_helper;
  late Database _database;
  String Defistable = 'Defis';
  String ColId = 'Id';
  String ColNom = 'nom';
  String ColMontant = 'montant';

  Defisdb_helper._createInstance();

  factory Defisdb_helper() {
    _defisdb_helper ??= Defisdb_helper._createInstance();
    return _defisdb_helper!;
  }

  Future<void> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path+'Defis.db';

    _database = await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $Defistable (
        $ColId INTEGER PRIMARY KEY AUTOINCREMENT,
        $ColNom TEXT,
        $ColMontant REAL
      )
    ''');
  }

  Future<List<Defis>> getDefis() async {
    await initializeDatabase(); // Ensure database initialization
    Database db = _database!;
    List<Map<String, dynamic>> maps = await db.query(Defistable);
    return List.generate(maps.length, (i) {
      return Defis.fromMapObject(maps[i]);
    });
  }

  Future<int> insertDefis(Defis defis) async {
    if (_database == null) {
      await initializeDatabase();
    }
    Database db = _database;
    return await db.insert(Defistable, defis.toMap());
  }
}
