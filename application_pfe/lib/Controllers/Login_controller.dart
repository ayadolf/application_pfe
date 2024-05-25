import 'package:application_pfe/models/Utilisateur.dart'; // Use lowercase 'utilisateur.dart' for consistency
import '../utils/Logindb_helper.dart';

class LoginController {
  final Logindb_helper _loginHelper = Logindb_helper.instance;

  Future<Utilisateur?> loginUser(String email, String password) async {
    // Check if the user with the provided email exists in the database
    return _loginHelper.loginUser(email, password);
  }
}
