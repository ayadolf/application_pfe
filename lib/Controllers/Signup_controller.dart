import 'package:flutter/material.dart';

import '../models/Utilisateur.dart';
import '../utils/Signupdb_helper.dart';

class Signup_controller {
  final Signupdb_helper _databaseHelper = Signupdb_helper.instance;

  Future<bool> registerUser(BuildContext context, String fullName, String email, String password) async {
    try {
      await Signupdb_helper.init(); // Initialize the database
      final user = Utilisateur(
        nom: fullName,
        email: email,
        motDePasse: password,
      );
      await _databaseHelper.insertUser(user);
      return true;
    } catch (error) {
      print('Error during registration: $error');
      return false;
    }
  }
}
