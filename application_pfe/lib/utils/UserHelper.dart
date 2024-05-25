import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class UserHelper {
  static late Database _database;

  static Future<void> initDatabase() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + 'User.db';

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _createDb,
      );
    } catch (e) {
      throw 'Error initializing database: $e';
    }
  }

  static void _createDb(Database db, int version) async {
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

  static Future<Map<String, dynamic>?> fetchUserDataById(int userId) async {
    try {
      final List<Map<String, dynamic>> users = await _database.query(
        'Utilisateur',
        where: 'id = ?',
        whereArgs: [userId],
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  static Future<void> updateUserData(Map<String, dynamic> userData) async {
    try {
      await _database.update(
        'Utilisateur',
        userData,
        where: 'id = ?',
        whereArgs: [userData['id']],
      );
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  static Future<String?> getUserNameById(int userId) async {
    try {
      final Map<String, dynamic>? userData = await fetchUserDataById(userId);
      if (userData != null) {
        return userData['nom']; // Assuming 'nom' is the field for the user's name
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }
  static Future<String?> getUserName(int userId) async {
    try {
      final Map<String, dynamic>? userData = await fetchUserDataById(userId);
      return userData?['nom']; // Assuming 'nom' is the key for the user's name in the database
    } catch (e) {
      print('Error fetching user name: $e');
      return null; // Return null or handle the error as needed
    }
  }

}
