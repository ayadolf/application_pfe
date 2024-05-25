import 'package:application_pfe/screens/Listedepense.dart';
import 'package:application_pfe/screens/Rapport.dart';
import 'package:application_pfe/screens/StatistiqueMois.dart';
import 'package:flutter/material.dart';

import '../auth/login/screen.dart';
import '../utils/UserHelper.dart';
import 'editProfile.dart';

// Define your constants here
const String tProfile = "Profile";
const double tDefaultSize = 16.0;
const String tProfileImage = "images/8742495.png";
const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Colors.black;

// Define your main screen widget here
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userName;
  static const int selectedUserId = 1; // Add this line for the selected user ID


  @override
  void initState() {
    super.initState();
    // Fetch user's information when the widget initializes
    fetchUserData();
  }

  // Method to fetch user's information
  void fetchUserData() async {
    // Replace this with your actual method to fetch user data
    Map<String, dynamic>? userData = await UserHelper.fetchUserDataById(selectedUserId);
    if (userData != null) {
      setState(() {
        userName = userData['nom'] ?? ''; // Assuming 'nom' is the field for the user's name
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(userName.isNotEmpty ? userName : tProfile, style: Theme.of(context).textTheme.headline4),
        actions: [

        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileImage(),
            const SizedBox(height: 10),
            Text(userName.isNotEmpty ? userName : tProfile, style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 5),
            ProfileButton(),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            ProfileMenuWidget(title: "expense", icon: Icons.attach_money,
                onPress: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Listedepense()),
            );}),
            ProfileMenuWidget(title: "Report",
                icon: Icons.report,
                onPress: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Rapport()),
            );}),
            ProfileMenuWidget(title: "Statistics",
                icon: Icons.bar_chart,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  StatistiqueMois()),
                  );
                }),
            const Divider(),
            const SizedBox(height: 3),
            ProfileMenuWidget(
              title: "View Profile",
              icon: Icons.info,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const editProfile()),
                );
              },
            ),
            ProfileMenuWidget(
              title: "Logout",
              icon: Icons.logout,
              textColor: Colors.red,
              endIcon: false,
              onPress: () => showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("LOGOUT", style: const TextStyle(fontSize: 20)),
        content: const Text("Are you sure, you want to Logout?"),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
              } catch (e) {
                print('Navigation error: $e');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[300], side: BorderSide.none),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const Image(image: AssetImage(tProfileImage)),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: tPrimaryColor),
            child: const Icon(
              Icons.edit,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          try {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const editProfile()));
          } catch (e) {
            print('Navigation error: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: tPrimaryColor,
          side: BorderSide.none,
          shape: const StadiumBorder(),
        ),
        child: const Text("Edit Profile", style: TextStyle(color: tDarkColor)),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.textColor = Colors.black,
    this.endIcon = true,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final Color textColor;
  final bool endIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Niveau d'élévation de l'ombre
      shadowColor: Colors.blue[200], // Couleur de l'ombre
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Marge de la carte
      child: ListTile(
        title: Text(title, style: TextStyle(color: textColor)),
        leading: Icon(icon),
        onTap: onPress,
        trailing: endIcon ? const Icon(Icons.arrow_forward_ios) : null,
      ),
    );
  }
}

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text("Update Profile Screen"),
      ),
    );
  }
}
