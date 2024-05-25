import 'package:application_pfe/screens/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Depense.dart';
import '../utils/Depensedb_helper.dart';

class formulaire2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyQuestionnaire(),
      ),
    );
  }
}

class MyQuestionnaire extends StatefulWidget {
  const MyQuestionnaire({Key? key}) : super(key: key);

  @override
  State<MyQuestionnaire> createState() => MyQuestionnaireState();
}

class MyQuestionnaireState extends State<MyQuestionnaire> {
  bool? transport;
  bool? wifi;
  bool? gym;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadCheckBoxState();
  }

  _loadCheckBoxState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      transport = _prefs.getBool('transport') ?? false;
      wifi = _prefs.getBool('wifi') ?? false;
      gym = _prefs.getBool('gym') ?? false;
    });
  }

  _saveCheckBoxState() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('transport', transport!);
    _prefs.setBool('wifi', wifi!);
    _prefs.setBool('gym', gym!);
  }

  void _navigateToExpenseForm(String expenseName) async {
    await _saveCheckBoxState(); // Save state before navigating
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpenseForm(expenseName: expenseName)),
    ).then((_) => _loadCheckBoxState()); // Reload state when returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -180.0,
            right: 90.0,
            child: Container(
              width: 400.0,
              height: 340.0,
              decoration: BoxDecoration(
                color: Colors.blue[300],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -150.0,
            left: 3,
            child: Container(
              width: 580.0,
              height: 330.0,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
              child: Text(
                'Finish',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: ListView(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Positioned(
                        top: 1.0,
                        left: 16,
                        right: 16,
                        child: Container(
                          width: 300.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Merci d'avoir participé 😍",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 0),
                              Text(
                                "Veuillez remplir ce document pour nous aider à améliorer les sessions futures.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 0),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "4. You have means of transportation?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Select one option.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0),
                            CheckboxListTile(
                              title: Text(
                                "Yes",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: transport ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  transport = newValue;
                                  if (newValue == true) {
                                    _navigateToExpenseForm('Transport');
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 0),
                            CheckboxListTile(
                              title: Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: transport == false,
                              onChanged: (newValue) {
                                setState(() {
                                  transport = !newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 0),
                      SizedBox(height: 0),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "5. Do you have Wi-Fi in your house?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Select one option.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0),
                            CheckboxListTile(
                              title: Text(
                                "Yes",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: wifi ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  wifi = newValue;
                                  if (newValue == true) {
                                    _navigateToExpenseForm('Wi-Fi');
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 0),
                            CheckboxListTile(
                              title: Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: wifi == false,
                              onChanged: (newValue) {
                                setState(() {
                                  wifi = !newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 0),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "6. Do you go to gym?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Select one option.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0),
                            CheckboxListTile(
                              title: Text(
                                "Yes",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: gym ?? false,
                              onChanged: (newValue) {
                                setState(() {
                                  gym = newValue;
                                  if (newValue == true) {
                                    _navigateToExpenseForm('Gym');
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 0),
                            CheckboxListTile(
                              title: Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: gym == false,
                              onChanged: (newValue) {
                                setState(() {
                                  gym = !newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({Key? key, required this.expenseName}) : super(key: key);
  final String expenseName;

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  late TextEditingController _title = TextEditingController();
  final _amount = TextEditingController();
  final _note= TextEditingController();
  DateTime? _date;
  String _selectedCategory = 'fixe';

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.expenseName); // Initialize controller with provided expenseName
  }

  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.input,
    );

    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  void _addExpense() {
    final name = _title.text;
    final amount = double.tryParse(_amount.text) ?? 0.0;
    final note = _note.text;
    final date = _date != null ? DateFormat('yyyy-MM-dd').format(_date!) : '';

    if (amount <= 0 || date.isEmpty) {
      // Show an error dialog if any required field is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.blue[100],
          title: Text('Error', style: TextStyle(color: Colors.black)),
          content: Text('Please fill in all fields correctly.', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      return;
    }

    // Create a Depense object with the retrieved data
    final depense = Depense(name: name, amount: amount, date: date, note: note, categorie: _selectedCategory);

    // Create an instance of Depensedb_helper
    final dbHelper = Depensedb_helper();

    // Insert the Depense object into the database using the helper instance
    dbHelper.insertDepense(depense).then((value) {
      if (value > 0) {
        // Show a success message if the insertion was successful
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Success', style: TextStyle(color: Colors.black)),
            content: Text('Expense added successfully.', style: TextStyle(color: Colors.black)),
            actions: [
              TextButton(
                onPressed: () {
                  // Clear the text controllers and reset the date and category
                  _title.clear();
                  _amount.clear();
                  _note.clear();
                  setState(() {
                    _date = null;
                    _selectedCategory = 'fixe';
                  });
                  // Navigate to the form page with existing expense responses
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => formulaire2()),
                  );
                },
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      } else {
        // Show an error message if the insertion failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add expense. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Expense',
          style: TextStyle(color: Colors.black), // Couleur du texte en noir
        ),
        backgroundColor: Colors.blue[100], // Couleur de fond en bleu
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    controller: _title,
                    readOnly: true, // Make the input read-only
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Expense name',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.track_changes), // Add icon here

                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Amount of expense',
                      labelStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.attach_money), // Add icon here
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    height: 200.0, // Set the desired height here
                    child: TextField(
                      controller: _note,
                      keyboardType: TextInputType.text,
                      maxLines: null, // Allow the TextField to expand vertically
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Write a note here',
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.note_outlined), // Add icon here

                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: _pickDate,
                    icon: Icon(Icons.calendar_today),
                  ),
                  Text(
                    _date != null ? DateFormat('dd/MM/yyyy').format(_date!) : 'Select date',
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              MaterialButton(
                onPressed: _addExpense,
                color: Colors.blue[200],
                textColor: Colors.white,
                height: 60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Changer le rayon pour ajuster la forme
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width: 15.0),
                    Text('Add expense',
                      style: TextStyle(fontSize: 20), // Change the font size here
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
