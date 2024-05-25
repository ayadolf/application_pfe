import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/Depense.dart';

class Depensedb_helper {
  static final Depensedb_helper instance = Depensedb_helper._internal();

  factory Depensedb_helper() => instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  // Add the init() method here
  static Future<void> init() async {
    _database = await instance.initializeDatabase();
  }

  final String depenseTable = 'Depense';
  final String colId = 'Id';
  final String colNom = 'name';
  final String colPrix = 'prix';
  final String colDate = 'date';
  final String colNote = 'Note';
  final String colCategorie = 'Categorie';

  Depensedb_helper._internal();

  Future<Database> initializeDatabase() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + 'depense.db';

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

  void _createDb(Database db, int newVersion) async {
      await db.execute('''
        CREATE TABLE $depenseTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colNom TEXT,
        $colPrix REAL,
        $colNote TEXT,
        $colDate TEXT,
        $colCategorie TEXT
    )
    ''');


  }

  Future<List<Map<String, dynamic>>> getDepense() async {
    final db = await database;
    var result = await db.query(depenseTable, orderBy: '$colId asc');
    return result;
  }

  Future<int> insertDepense(Depense depense) async {
    final db = await database;
    var result = await db.insert(depenseTable, depense.tomap());
    return result;
  }


  Future<Depense?> getDepenseById(int id) async {
    final db = await database;
    var result = await db.query(
      depenseTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) {
      return null;
    } else {
      return Depense.fromMapObject(result.first);
    }
  }

  Future<int?> getDepenseCount() async {
    final db = await database;
    int? count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $depenseTable'),
    );
    return count;
  }

  Future<List<Depense>> getAllDepensesSortedByDate(String category) async {
    final db = await database;
    var result = await db.query(
      depenseTable,
      where: '$colCategorie = ?',
      whereArgs: [category],
      orderBy: '$colDate asc',
    );
    List<Depense> depenses = result.isNotEmpty
        ? result.map((e) => Depense.fromMapObject(e)).toList()
        : [];
    return depenses;
  }

  Future<int> deleteAllDepenses() async {
    final db = await database;
    int result = await db.rawDelete('DELETE FROM $depenseTable');
    return result;
  }



  Future<List<Depense>> getAllDepensesSortedByDate3() async {
    final db = await database;
    var result = await db.query(depenseTable, orderBy: '$colDate asc');
    List<Depense> depenses = result.isNotEmpty ? result.map((e) =>
        Depense.fromMapObject(e)).toList() : [];
    return depenses;
  }
  Future<List<Depense>> getDepensesForMonth(int month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      depenseTable,
      where: "strftime('%m', $colDate) = ?",
      whereArgs: [month.toString().padLeft(2, '0')], // Ensure 2-digit month format
    );

    List<Depense> depenses = maps.isNotEmpty
        ? maps.map((e) => Depense.fromMapObject(e)).toList()
        : [];

    return depenses;
  }
  Future<List<Depense>> getDepensesForYear(int year) async {
    final db = await database;
    var result = await db.query(
      depenseTable,
      where: "strftime('%Y', $colDate) = ?",
      whereArgs: [year.toString()],
    );

    List<Depense> depenses = result.isNotEmpty
        ? result.map((e) => Depense.fromMapObject(e)).toList()
        : [];

    return depenses;
  }
  Future<List<double>> getExpenseAmountsForMonth(int month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      depenseTable,
      where: "strftime('%m', $colDate) = ?",
      whereArgs: [month.toString().padLeft(2, '0')], // Ensure 2-digit month format
      columns: ['prix'], // Select only the 'prix' (amount) column
    );

    List<double> expenseAmounts = maps.isNotEmpty
        ? maps.map((e) => e['prix'] as double).toList()
        : [];

    return expenseAmounts;
  }
  Future<int> deleteDepenseByNameAndDate(String name, String date) async {
    final db = await database;
    var result = await db.rawDelete(
      'DELETE FROM $depenseTable WHERE $colNom = ? AND $colDate = ?',
      [name, date],
    );
    return result;
  }
  Future<int> updateDepense(Depense depense) async {
    final db = await database;
    var result = await db.update(
      depenseTable,
      depense.tomap(),
      where: '$colNom = ? AND $colDate = ?',
      whereArgs: [depense.name, depense.date],
    );

    return result;
  }


  Future<int> deleteDepense(int id) async {
    final db = await database;
    var result = await db.rawDelete(
      'DELETE FROM $depenseTable WHERE $colId = ?',
      [id],
    );
    return result;
  }
  // Method to get expenses by name from the database
  Future<List<Depense>> getDepensesByName(String name) async {
    final db = await database;
    var result = await db.query(
      depenseTable,
      where: '$colNom = ?',
      whereArgs: [name],
    );
    List<Depense> depenses = result.isNotEmpty
        ? result.map((e) => Depense.fromMapObject(e)).toList()
        : [];
    return depenses;
  }

  Future<List<Depense>> getDepensesForMonthAndYear(int month, int year) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      depenseTable,
      where: "strftime('%m', $colDate) = ? AND strftime('%Y', $colDate) = ?",
      whereArgs: [month.toString().padLeft(2, '0'), year.toString()],
    );

    List<Depense> depenses = maps.isNotEmpty
        ? maps.map((e) => Depense.fromMapObject(e)).toList()
        : [];

    return depenses; // Return the list of depenses
  }







}
