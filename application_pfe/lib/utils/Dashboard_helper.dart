import 'dart:io';
import 'package:application_pfe/utils/UserHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Dashboard_helper {
  static Database? _database;

  // Method to initialize the database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Method to open and initialize the database
  static Future<Database> initDatabase() async {
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

  // Method to create the database tables
  static Future<void> _createDb(Database db, int version) async {
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

  // Method to fetch the user's salary from the database
  static Future<String> getUserSalary() async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query('Utilisateur');
    if (result.isNotEmpty) {
      return result.first['salaire'].toString();
    } else {
      throw 'User salary not found in the database';
    }
  }

  // Method to update the user's salary in the database
  static Future<void> updateUserSalary(double newSalary) async {
    final Database db = await database;
    int userId = await getUserId(); // Get the user's ID
    try {
      await db.update(
        'Utilisateur',
        {'salaire': newSalary},
        where: 'id = ?', // Assuming the user's ID is used for identifying the record
        whereArgs: [userId], // Pass the user's ID as an argument
      );
    } catch (e) {
      throw 'Error updating user salary: $e';
    }
  }

  // Method to fetch the user's ID from the database
  static Future<int> getUserId() async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Utilisateur',
      columns: ['id'],
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      throw Exception('User ID not found');
    }
  }
  static Future<double> getTotalExpensesByMonth(int month) async {
    final Database? db = await database; // Check for successful initialization
    if (db == null) return 0.0; // Indicate error or default value

    try {
      List<Map<String, dynamic>> result = await db.query(
        'Depenses',
        columns: ['amount'],
        where: 'strftime("%m", date) = ?', // Filter by month
        whereArgs: [month.toString()], // Pass the month as an argument
      );
      double totalExpenses = 0.0;
      for (var item in result) {
        totalExpenses += double.parse(item['amount'].toString());
      }
      return totalExpenses;
    } catch (e) {
      print('Error fetching total expenses for month $month: $e');
      return 0.0; // Indicate error or default value
    }
  }

  static Future<String?> getUserName(int userId) async {
    try {
      // Replace 'DatabaseHelper' with the name of your actual database helper class
      UserHelper helper = UserHelper();
      // Assuming your method to get user name from the database is 'getUserNameById'
      String? userName = await UserHelper.getUserNameById(userId);
      return userName;
    } catch (e) {
      print('Error fetching user name: $e');
      return ''; // Return an empty string or handle the error as needed
    }
  }

  }

