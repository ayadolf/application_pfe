import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:application_pfe/models/utilisateur.dart'; // Update the import path as per your project structure

class EditProfildb_helper {
  static Database? _database;
  static final EditProfildb_helper instance = EditProfildb_helper._();
  static EditProfildb_helper? _signupdbHelper; // Declare _signupdbHelper as static

  EditProfildb_helper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Utilisateur("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "nom TEXT,"
              "email TEXT,"
              "motDePasse TEXT,"
              "phone TEXT,"
              "profession TEXT,"
              "salaire REAL,"
              "sexe TEXT,"
              "age INTEGER,"
              "status TEXT,"
              "profilePicture TEXT" // Add column for profile picture
              ")",
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(Utilisateur user) async {
    final db = await database;
    await db.insert(
      'Utilisateur',
      user.tomap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> init() async {
    _signupdbHelper = EditProfildb_helper.instance;
    await _signupdbHelper!._initializeDatabaseHelper(); // Call _initializeDatabaseHelper
  }

  Future<void> _initializeDatabaseHelper() async {
    _database = await _initDatabase();
  }

  Future<Utilisateur> getUserInfo(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Utilisateur',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return Utilisateur.fromMapObject(maps.first);
    } else {
      throw Exception("User not found");
    }
  }

  Future<void> updateUser(Utilisateur user) async {
    final db = await database;
    await db.update(
      'Utilisateur',
      user.tomap(),
      where: "id = ?",
      whereArgs: [1], // Use id from the user object
    );
  }

  // Add a method to update profile picture
  Future<void> updateProfilePicture(int userId, String profilePicture) async {
    final db = await database;
    await db.update(
      'Utilisateur',
      {'profilePicture': profilePicture}, // Update only profile picture
      where: "id = ?",
      whereArgs: [1],
    );
  }
}
