import 'package:flutter/material.dart';
import 'package:application_pfe/screens/StatistiqueMois.dart';
import 'package:application_pfe/utils/Depensedb_helper.dart';
import 'package:application_pfe/auth/login/screen.dart';
import 'package:application_pfe/models/Depense.dart';
import 'package:application_pfe/screens/Rapport.dart';
import 'package:application_pfe/utils/Dashboard_helper.dart';
import 'package:application_pfe/utils/UserHelper.dart';
import 'package:application_pfe/screens/Listedepense.dart';
import 'package:application_pfe/screens/Profile.dart';

import 'Challenge.dart';
import 'DepenseDetails.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? name;
  String userSalary = '';
  late double remainingBudget;
  double totalExpenses = 0.0;
  int currentMonth = DateTime.now().month;
  static const String tProfileImage = "images/8742495.png";

  TextEditingController _salaryController = TextEditingController();
  List<Depense> filteredExpenses = []; // Declare filteredExpenses here

  Depensedb_helper helper = Depensedb_helper();

  @override
  void initState() {
    super.initState();
    // Initialize the database before fetching user data
    Depensedb_helper().initializeDatabase().then((_) {
      fetchUserName();
      fetchUserSalary();
      fetchTotalExpenses();
    });
  }

  void fetchUserName() async {
    try {
      print('Fetching user name...');
      String? userName = await UserHelper.getUserName(1);
      print('User name retrieved: $userName');
      setState(() {
        name = userName;
      });
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  void filterExpensesByName(String expenseName) async {
    // Convert the search query to lowercase
    String query = expenseName.toLowerCase();

    // Check if the expense name is empty
    if (query.isEmpty) {
      // If the name is empty, display all expenses
      setState(() {
        filteredExpenses.clear();
        filteredExpenses = filteredExpenses.toList(); // Copy all expenses to filteredExpenses
      });
      return;
    }

    try {
      // Query expenses from the database
      List<Depense> allExpenses = await helper.getAllDepensesSortedByDate3();

      // Filter expenses based on the lowercase query
      List<Depense> filteredExpenses = allExpenses.where((expense) => expense.name.toLowerCase().contains(query)).toList();

      setState(() {
        // Update the UI with filtered expenses
        this.filteredExpenses = filteredExpenses;
      });
      _showSearchResultNotification(filteredExpenses.length, filteredExpenses.first);

      // Print the filtered expenses to the console
      print('Filtered Expenses: $filteredExpenses');
    } catch (e) {
      print('Error filtering expenses: $e');
      // Handle error (e.g., display an error message)
    }
  }

  void fetchUserSalary() async {
    try {
      String salary = await Dashboard_helper.getUserSalary();
      setState(() {
        userSalary = salary;
        _salaryController.text = userSalary;
      });
    } catch (e) {
      print('Error fetching user salary: $e');
    }
  }

  void fetchTotalExpenses() async {
    try {
      List<double> expenseAmounts = await helper.getExpenseAmountsForMonth(currentMonth);
      double totalExpenseAmount = expenseAmounts.fold(0.0, (sum, amount) => sum + amount);
      setState(() {
        totalExpenses = totalExpenseAmount;
        remainingBudget = double.parse(userSalary) - totalExpenses;
      });
    } catch (e) {
      print('Error fetching total expenses: $e');
    }
  }

  void updateUserSalary(String newSalary) async {
    try {
      double salary = double.parse(newSalary);
      await Dashboard_helper.updateUserSalary(salary);
      setState(() {
        userSalary = salary.toStringAsFixed(2);
        _salaryController.text = userSalary;
      });
    } catch (e) {
      print('Error updating user salary: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double remainingBudget = double.parse(userSalary) - totalExpenses;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        drawerTheme: DrawerThemeData(
          width: 210,
          backgroundColor: Color(0xFFE0F2F1),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    filterExpensesByName(value);
                  },
                ),
              ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen()));
                },
                child: Container(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(tProfileImage),
                  ),
                ),
              ),
            ],
          ),
          actions: [

          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*Expanded(
                child: ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredExpenses[index].name),
                      subtitle: Text('${filteredExpenses[index].date} - \$${filteredExpenses[index].amount.toStringAsFixed(2)}'),
                      onTap: () {
                        // Handle onTap event when the user selects a suggestion
                        // For example, you can navigate to a detail screen or perform an action.
                      },
                    );
                  },
                ),
              ),*/
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 3.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome Back, $name',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              GestureDetector(
                onTap: () {
                  _showEditSalaryDialog();
                },
                child: Container(
                  width: 350.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Color(0xFF5FA8D3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              "My Salary :",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '\MAD $userSalary',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showEditSalaryDialog();
                                },
                                icon: Icon(Icons.edit),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                child: Container(
                  width: 350.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Color(0xff94C3F6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0.0, right: 100.0),
                            child: Text(
                              "The remainder:",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '\MAD $remainingBudget',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: remainingBudget >= 0 ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChallengeScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Container(
                    width: 350,
                    height: 120.0,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create a Saving goal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'The only way to save money is not to spend it',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 30,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.credit_card),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 500,
                    height: 80,
                    color: Colors.transparent,
                    child: Text(
                      'Quick Access',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Listedepense()),
                      );
                    },
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Container(
                          width: 100,
                          height: 100.0,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.monetization_on),
                              ),
                              SizedBox(height: 2),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'Expense',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Rapport()),
                      );
                    },
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Container(
                          width: 100,
                          height: 100.0,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.list_alt),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'Report',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StatistiqueMois()),
                      );
                    },
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Container(
                          width: 100,
                          height: 100.0,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.bar_chart_outlined),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'Statistics',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.grey[10],
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    "Home",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Expenses",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  leading: Icon(Icons.percent),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Listedepense()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Report",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  leading: Icon(Icons.list_alt),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Rapport()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Settings",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    ////
                  },
                ),
                ListTile(
                  title: Text(
                    "Log out",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.grey),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart_rounded, color: Colors.grey),
              label: 'Line',

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard, color: Colors.grey),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.grey),
              label: 'Chats',
            ),
          ],

          onTap: (int index) {
            // Handle navigation based on the tapped item
            switch (index) {
              case 0:
              // Navigate to the Home screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
                break;
              case 1:
              // Navigate to the statistiques screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatistiqueMois()),
                );
                break;
              case 2:
              // Navigate to the report screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Rapport()),
                );
                break;
              case 3:
              // Navigate to the profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
                break;
              default:
                break;
            }
          },
        ),
      ),
    );
  }

  void _showEditSalaryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Salary'),
          content: TextField(
            controller: _salaryController,
            decoration: InputDecoration(hintText: 'Enter your new salary'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                updateUserSalary(_salaryController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  void _showSearchResultNotification(int resultCount, Depense expense) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Result'),
          content: Text('Found $resultCount result(s)'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('View'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpenseDetailScreen(expense: expense)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}