import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:application_pfe/models/Utilisateur.dart'; // Update the import path as per your project structure

class Logindb_helper {
  static Database? _database;
  static final Logindb_helper instance = Logindb_helper._();
  static Logindb_helper? _logindbHelper;

  Logindb_helper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + 'User.db';

      var depenseDatabase = await openDatabase(
        path,
        version: 1,
        onCreate: _createDb, // Corrected reference to _createDb method
      );
      return depenseDatabase;
    } catch (e) {
      throw 'Error initializing database: $e';
    }
  }

  static Future<void> init() async {
    _logindbHelper = Logindb_helper.instance;
    await _logindbHelper!._initializeDatabaseHelper();
  }

  Future<void> _initializeDatabaseHelper() async {
    _database = await _initDatabase();
  }

  Future<Utilisateur?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Utilisateur',
      where: 'email = ? AND motDePasse  = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return Utilisateur.fromMapObject(maps.first);
    }
    return null;
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

  Future<bool> verifyEmail(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        'Utilisateur',
        columns: ['id'],
        where: 'email = ?',
        whereArgs: [email],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('An error occurred while verifying email: $e');
      return false; // Return false if an error occurs
    }
  }

  Future<void> updateUser(Utilisateur user) async {
    final db = await database;
    await db.update(
      'Utilisateur',
      user.tomap(),
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<Utilisateur?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        'Utilisateur',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isNotEmpty) {
        return Utilisateur.fromMapObject(result.first);
      } else {
        return null; // Return null if no user found with the provided email
      }
    } catch (e) {
      print('An error occurred while getting user by email: $e');
      return null; // Return null if an error occurs
    }
  }
}


