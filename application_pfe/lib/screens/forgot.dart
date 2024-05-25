import 'package:application_pfe/auth/login/screen.dart';
import 'package:flutter/material.dart';

import '../utils/Logindb_helper.dart';

class forgotScreen extends StatefulWidget {
  const forgotScreen({Key? key}) : super(key: key);

  @override
  State<forgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<forgotScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  bool _obscureTextOldPassword = true;
  bool _obscureTextNewPassword = true;

  // Function to handle password modification
// Function to handle password modification
  void _modifyPassword() {
    String email = _emailController.text;
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;

    // Add logic to verify email here
    Logindb_helper.instance.verifyEmail(email).then((emailExists) {
      if (emailExists) {
        // Email exists, proceed with password modification
        // Update the password in the database
        Logindb_helper.instance.loginUser(email, oldPassword).then((user) {
          if (user != null) {
            // User found with the provided email and old password
            // Update the password for this user in the database
            user.motDePasse = newPassword;
            // Call the update method of your database helper
            Logindb_helper.instance.updateUser(user).then((_) {
              // Password updated successfully
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password modified successfully'),
                  duration: Duration(seconds: 3),
                ),
              );
            }).catchError((error) {
              // Error occurred while updating the password
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to modify password. Please try again later.'),
                  duration: Duration(seconds: 3),
                ),
              );
              print('Error updating password: $error');
            });
          } else {
            // User not found with the provided email and old password
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid old password'),
                duration: Duration(seconds: 3),
              ),
            );
            print('Invalid old password');
          }
        });
      } else {
        // Email does not exist, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email does not exist'),
            duration: Duration(seconds: 3),
          ),
        );
        print('Email does not exist');
      }
    }).catchError((error) {
      // Exception handler
      print('An error occurred: $error');
      // Display a message to the user indicating the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while modifying the password. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

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
                          "Forgot Password!",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: screenWidth / 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF03253A),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Password Recovery: Enter your email address to receive reset instructions,",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: screenWidth / 24,
                        color: Color(0xFF03253A),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email, color: Colors.black),
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(width: 1.0, color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 1.0, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextFormField(
                              controller: _oldPasswordController,
                              obscureText: _obscureTextOldPassword,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outlined, size: 20),
                                labelText: 'Old Password',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(width: 1.0, color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 1.0, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureTextOldPassword ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextOldPassword = !_obscureTextOldPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextFormField(
                              controller: _newPasswordController,
                              obscureText: _obscureTextNewPassword,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outlined, size: 20),
                                labelText: 'New Password',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(width: 1.0, color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 1.0, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureTextNewPassword ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextNewPassword = !_obscureTextNewPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: _modifyPassword, // Call the function to modify password
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
                            "Modify",
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
                      child: Text(
                        "Go back to Login In",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          color: Color(0xFF03253A),
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

  Widget square(
      double y, double opacity, double screenWidth, double screenHeight) {
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
