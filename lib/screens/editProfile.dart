import 'package:flutter/material.dart';
import '../models/Utilisateur.dart';
import '../utils/UserHelper.dart';

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<editProfile> {
  late Utilisateur utilisateur;
  TextEditingController _fullNameEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _salaryEditingController = TextEditingController();
  TextEditingController _jobEditingController = TextEditingController();
  TextEditingController _ageEditingController = TextEditingController();
  static const String tProfileImage = "images/8742495.png";

  int selectedUserId = 1; // Initialize with default user ID

  @override
  void initState() {
    super.initState();
    // Fetch user's information when the widget initializes
    fetchUserData();
  }

  // Method to fetch user's information
  void fetchUserData() async {
    Map<String, dynamic>? userData = await UserHelper.fetchUserDataById(selectedUserId);
    if (userData != null) {
      print('User data retrieved: $userData');
      utilisateur = Utilisateur.fromMapObject(userData);
      _fullNameEditingController.text = utilisateur.nom;
      _emailEditingController.text = utilisateur.email;
      _salaryEditingController.text = utilisateur.salaire.toString();
      _jobEditingController.text = utilisateur.profession;
      _ageEditingController.text = utilisateur.age.toString();
    } else {
      print('User data is null');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profil',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFF03253A),
            fontSize: 20.2,
          ),
        ),
        centerTitle: true, // Centre le titre de l'app bar
        actions: [
          TextButton(
            onPressed: () {
              // Save changes
              saveChanges();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: profileView(),
    );
  }

  Widget profileView() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 35),
                  GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(image: AssetImage(tProfileImage)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _fullNameEditingController,
                        decoration: InputDecoration(
                          labelText: 'FullName',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(width: 1.0, color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1.0, color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _emailEditingController,
                        decoration: InputDecoration(
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
                          contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _salaryEditingController,
                        keyboardType: TextInputType.number, // Set keyboard type to numeric
                        decoration: InputDecoration(
                          labelText: 'Salary',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(width: 1.0, color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1.0, color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _jobEditingController,
                        decoration: InputDecoration(
                          labelText: 'Job',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(width: 1.0, color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1.0, color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _ageEditingController,
                        keyboardType: TextInputType.number, // Set keyboard type to numeric
                        decoration: InputDecoration(
                          labelText: 'Age',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(width: 1.0, color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 1.0, color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void saveChanges() {
    // Update user information in the database
    utilisateur.nom = _fullNameEditingController.text;
    utilisateur.email = _emailEditingController.text;
    utilisateur.salaire = double.parse(_salaryEditingController.text);
    utilisateur.profession = _jobEditingController.text;
    utilisateur.age = int.parse(_ageEditingController.text);

    // Add the 'id' field to the userData map
    Map<String, dynamic> userData = utilisateur.tomap();
    userData['id'] = 1; // Assuming the user ID is always 1

    // Update user data in the database
    UserHelper.updateUserData(userData);

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Changes saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

}
