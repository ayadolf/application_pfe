import 'package:flutter/material.dart';
import 'package:application_pfe/models/utilisateur.dart';

import '../utils/EditProfil.dart';
import '../utils/Signupdb_helper.dart'; // Update the import path as per your project structure

class Profil_controller {
  final EditProfildb_helper _databaseHelper = EditProfildb_helper.instance;

  Future<bool> insertUser(BuildContext context, String fullName, String email, String password) async {
    try {
      final user = Utilisateur(

        nom: fullName,
        email: email,
        motDePasse: password,  salaire: 0
      );
      await _databaseHelper.insertUser(user);
      return true;
    } catch (error) {
      print('Error during profile insertion: $error');
      return false;
    }
  }

  Future<bool> updateUser(BuildContext context, String fullName, String email, String password) async {
    try {
      final user = Utilisateur(
        nom: fullName,
        email: email,
        motDePasse: password,  salaire: 0,
      );
      await _databaseHelper.updateUser(user);
      return true;
    } catch (error) {
      print('Error during profile update: $error');
      return false;
    }
  }
  Future<bool> updateProfilePicture(BuildContext context, int userId, String profilePicture) async {
    try {
      await _databaseHelper.updateProfilePicture(userId, profilePicture);
      return true;
    } catch (error) {
      print('Error during profile picture update: $error');
      return false;
    }
  }
}
