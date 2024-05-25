import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth/login/screen.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()))
    ,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/logo.jpg'),
              fit: BoxFit.cover, // Fills the entire container
            ),
          ),
        ),
      ),
    );
  }
}
