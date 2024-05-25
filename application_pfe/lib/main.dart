import 'package:application_pfe/auth/register/register.dart';
import 'package:application_pfe/screens/Challenge.dart';
import 'package:application_pfe/screens/Dashboard.dart';
import 'package:application_pfe/screens/Profile.dart';
import 'package:application_pfe/screens/Rapport.dart';
import 'package:application_pfe/screens/StatistiqueMois.dart';
import 'package:application_pfe/screens/forgot.dart';
import 'package:application_pfe/screens/formulaire.dart';
import 'package:application_pfe/utils/Depensedb_helper.dart';
import 'package:application_pfe/utils/UserHelper.dart';
import 'package:flutter/material.dart';
import 'package:application_pfe/screens/CreateChallenge.dart';
import 'package:application_pfe/utils/Logindb_helper.dart';
import 'package:application_pfe/utils/Signupdb_helper.dart';
import 'package:application_pfe/utils/Defisdb_helper.dart';
import 'auth/login/screen.dart';
import 'package:application_pfe/screens/Listedepense.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the login database
  Logindb_helper.init();

  // Initialize the signup database
  Signupdb_helper.init();
  Depensedb_helper.init();
  // Initialize the defis database
  Defisdb_helper().initializeDatabase();
  UserHelper.initDatabase();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => RegisterScreen(),
        '/LoginScreen': (context) => LoginScreen(), // Route for LoginScreen
        '/formulaire': (context) => formulaire(), // Define the route for formulaire
      },
    );
  }
}