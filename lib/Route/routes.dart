import 'package:flutter/material.dart';
import 'package:application_pfe/screens/StatistiqueMois.dart';
import 'package:application_pfe/screens/Rapport.dart';
import 'package:application_pfe/auth/login/screen.dart';
import 'package:application_pfe/screens/Listedepense.dart';
import 'package:application_pfe/screens/Dashboard.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    '/': (context) => LoginScreen(),
    '/expense': (context) => Listedepense(),
    '/report': (context) => Rapport(),
    '/login': (context) => LoginScreen(),
    '/statistique': (context) => StatistiqueMois(),
  };
}
