import '../models/Depense.dart';
import '../utils/Depensedb_helper.dart';

class DepenseController {
  // Instance of the database helper
  final Depensedb_helper dbHelper = Depensedb_helper();

  // Insert a depense into the database
  Future<int> insertDepense(Depense depense) async {
    return dbHelper.insertDepense(depense);
  }

  // Get a depense by ID from the database
  Future<Depense?> getDepenseById(int id) async {
    return dbHelper.getDepenseById(id);
  }

  // Get total number of depenses in the database
  Future<int?> getDepenseCount() async {
    return dbHelper.getDepenseCount();
  }

  // Get all depenses from the database sorted by date
  Future<List<Depense>> getAllDepensesSortedByDate(String category) async {
    return dbHelper.getAllDepensesSortedByDate(category); // Add category parameter here
  }


  // Delete all depenses from the database
  Future<int> deleteAllDepenses() async {
    return dbHelper.deleteAllDepenses();
  }






  Future<List<Depense>> getDepensesForMonth(int month) async {
    return dbHelper.getDepensesForMonth(month);
  }
  Future<List<Depense>> getDepensesForYear(int year) async {
    return dbHelper.getDepensesForMonth(year);
  }
  Future<List<Depense>> getAllDepensesSortedByDate3() async {
    return dbHelper.getAllDepensesSortedByDate3();
  }
// Delete a depense from the database
  Future<int> deleteDepense(String name,String date) async {
    return dbHelper.deleteDepenseByNameAndDate(name,date);
  }
  // Update a depense in the database
  Future<int> updateDepense(Depense depense) async {
    return dbHelper.updateDepense(depense);
  }

  Future<List<Depense>> getDepensesForMonthAndYear(int month,int year) async {
    return dbHelper.getDepensesForMonthAndYear(month,year);
  }



}
