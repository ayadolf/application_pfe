import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/Utilisateur.dart';

class Signupdb_helper {
  static Database? _database;
  static final Signupdb_helper instance = Signupdb_helper._();
  static Signupdb_helper? _signupDbHelper;

  Signupdb_helper._();

  Future<Database> initializeDatabase() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + 'User.db';

      var depenseDatabase = await openDatabase(
        path,
        version: 1,
        onCreate: _createDb,
      );
      return depenseDatabase;
    } catch (e) {
      throw 'Error initializing database: $e';
    }
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Utilisateur (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        email TEXT,
        motDePasse TEXT,
        profession TEXT,
        salaire REAL,
        age INTEGER
      )
    ''');
  }

  Future<void> insertUser(Utilisateur user) async {
    final db = await _database;
    await db?.insert(
      'Utilisateur',
      user.tomap(), // Corrected method name to toMap()
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _initializeDatabaseHelper() async {
    try {
      _database = await initializeDatabase(); // Await initialization
    } catch (e) {
      print('Error initializing database: $e');
      throw 'Error initializing database: $e';
    }
  }

  static Future<void> init() async {
    _signupDbHelper = Signupdb_helper.instance;
    await _signupDbHelper!._initializeDatabaseHelper();
  }
}
