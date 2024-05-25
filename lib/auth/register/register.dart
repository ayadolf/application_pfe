import 'package:application_pfe/auth/login/screen.dart';
import 'package:flutter/material.dart';
import '../../screens/formulaire.dart';

import '../../controllers/signup_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  final Signup_controller _signupController = Signup_controller(); // Create an instance of SignupController

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent,
        height: screenHeight,
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.4,
              color: Colors.lightBlueAccent,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight / 12,
                ),
              ),
            ),
            square(-30, 0.12, screenWidth, screenHeight),
            square(-10, 0.3, screenWidth, screenHeight),
            square(10, 1, screenWidth, screenHeight),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight / 2,
                width: screenWidth,
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth / 11,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Register with us!",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: screenWidth / 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF03253A),
                          ),
                        ),
                      ),
                    ),
                          Text(
                            "Your information is safe with us,",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: screenWidth / 24,
                              color: Color(0xFF03253A),
                            ),
                          ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                         hintText: 'Full name',
                          prefixIcon: Icon(Icons.person, size: 20),
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email, size: 20),
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_outlined, size: 20),
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    GestureDetector(
                      onTap: () async {
                        // Check if all text fields are filled
                        if (_fullNameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in all fields'),
                              backgroundColor: Colors.red, // Optional: Customize snackbar color
                            ),
                          );
                          return; // Exit the function if any field is empty
                        }

                        // Proceed with registration if all fields are filled
                        bool signUpSuccess = await _signupController.registerUser(
                          context,
                          _fullNameController.text,
                          _emailController.text,
                          _passwordController.text,
                        );


                        if (signUpSuccess) {
                          // If signup was successful, show a snackbar to notify the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Account created successfully!'),
                              backgroundColor: Colors.blue, // Optional: Customize snackbar color
                            ),
                          );

                          // Navigate to another screen upon successful signup
                          // Example:
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => formulaire()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error, try again !'),
                              backgroundColor: Colors
                                  .blue, // Optional: Customize snackbar color
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.facebook,
                            color: Color(0xFF03253A),
                          ),
                          onPressed: () {
                            // Handle Facebook login action here
                          },
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          icon: Icon(
                            Icons.apple,
                            color: Color(0xFF03253A),
                          ),
                          onPressed: () {
                            // Handle Gmail login action here
                          },
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          icon: Icon(
                            Icons.email,
                            color: Color(0xFF03253A),
                          ),
                          onPressed: () {
                            // Handle WhatsApp login action here
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 0.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Text(
                          "Already have an account? log in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget square(double y, double opacity, double screenWidth, double screenHeight) {
    return Center(
      child: Transform.translate(
        offset: Offset(screenWidth / 30, y),
        child: Transform.rotate(
          angle: -0.4,
          child: Container(
            height: screenHeight / 3,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: BorderRadius.circular(55),
            ),
          ),
        ),
      ),
    );
  }
}

