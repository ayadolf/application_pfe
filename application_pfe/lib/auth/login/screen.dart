import 'package:flutter/material.dart';

import '../../Controllers/Login_controller.dart';
import '../../models/Utilisateur.dart';
import '../../screens/Dashboard.dart';
import '../register/register.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final LoginController _loginController = LoginController(); // Create an instance of LoginController

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
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight / 8,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Welcome Back !!",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: screenWidth / 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                    Text(
                      "To connect to your account, please enter your email address and password,",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: screenWidth / 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
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
                          prefixIcon: Icon(Icons.lock_outlined,size: 20),
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
                    SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () async {
                        // Call the loginUser method from the controller
                        Utilisateur? user = (await _loginController.loginUser(
                          _emailController.text,
                          _passwordController.text,
                        )) as Utilisateur?;
                        // Check if user is authenticated
                        if (user != null) {
                          // Navigate to the home screen or any other screen upon successful login
                          // Example:
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Dashboard()),
                          );
                        } else {
                          // Show error message if login fails
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Invalid email or password'),
                              backgroundColor: Colors.red, // Customize snackbar color
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
                            "Log in",
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
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.facebook,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Handle Facebook login action here
                          },
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          icon: Icon(
                            Icons.apple,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Handle Gmail login action here
                          },
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          icon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Handle WhatsApp login action here
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                      width: double.infinity,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Don't have an account? Sign up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
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

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Text(
          'Sign Up Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
