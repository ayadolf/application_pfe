import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Defis.dart';
import '../utils/Defisdb_helper.dart';
import 'Challenge.dart';

class CreateChallenge extends StatefulWidget {
  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallenge> {
  late TextEditingController _titleController;
  late double _amount;
  late TextEditingController _amountController;
  late Defisdb_helper _defisdbHelper;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amount = 0.0;
    _amountController = TextEditingController();
    _defisdbHelper = Defisdb_helper();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _defisdbHelper.initializeDatabase(); // Initialize the database
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Challenge',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[100],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = double.parse(value);
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[100], // Text color
                padding: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
              onPressed: () async {
                // Create and insert the challenge into the database
                final newChallenge = Defis(0, _amount, _titleController.text);
                await _defisdbHelper.insertDefis(newChallenge);

                // Show confirmation dialog and navigate to ChallengeList
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Confirmation"),
                      content: Text("Challenge created successfully!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.pop(context); // Pop CreateChallenge screen
                            Navigator.pushReplacement( // Navigate to ChallengeList
                              context,
                              MaterialPageRoute(builder: (context) => ChallengeScreen()),
                            );
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Create Challenge',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class ChallengeDetailsScreen1 extends StatefulWidget {
  final String title;
  final String date;
  final String amount;

  const ChallengeDetailsScreen1({
    Key? key,
    required this.title,
    required this.date,
    required this.amount,
  }) : super(key: key);

  @override
  _ChallengeDetailsScreenState createState() =>
      _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen1> {
  late SharedPreferences _prefs;
  late String _challengeKey;
  late List<bool> _daysCompleted;
  bool _showCongratulations = false;

  @override
  void initState() {
    super.initState();
    _challengeKey = '${widget.title}_${widget.date}_${widget.amount}';
    _loadCheckboxState();
  }

  Future<void> _loadCheckboxState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _daysCompleted = List.generate(
        31,
            (index) => _prefs.getBool('$_challengeKey/day_$index') ?? false,
      );
    });
  }

  Future<void> _saveCheckboxState(int index, bool value) async {
    await _prefs.setBool('$_challengeKey/day_$index', value);
  }

  bool _isAllCompleted() {
    return _daysCompleted.every((day) => day);
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You finished your saving challenge."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _daysCompleted = List.filled(31, false); // Reset checkboxes
                });
                for (int i = 0; i < _daysCompleted.length; i++) {
                  _saveCheckboxState(i, false); // Save the reset state
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text("Challenge Details"),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _daysCompleted = List.filled(31, true);
              });
              for (int i = 0; i < _daysCompleted.length; i++) {
                await _saveCheckboxState(i, true);
              }
              _showCongratulationsDialog(); // Show congratulatory message
            },
            child: Text(
              "Select All",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  _daysCompleted.length,
                      (index) => ListTile(
                    title: Text("Day ${index + 1}"),
                    trailing: Checkbox(
                      value: _daysCompleted[index],
                      onChanged: (value) {
                        setState(() {
                          _daysCompleted[index] = value ?? false;
                          _saveCheckboxState(index, value ?? false);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChallengeDetailsScreen4 extends StatefulWidget {
  final String challengeId; // Unique identifier for the challenge

  const ChallengeDetailsScreen4({Key? key, required this.challengeId})
      : super(key: key);

  @override
  _ChallengeDetailsScreen4State createState() =>
      _ChallengeDetailsScreen4State();
}

class _ChallengeDetailsScreen4State extends State<ChallengeDetailsScreen4> {
  late SharedPreferences _prefs;
  late List<bool> _daysCompleted;
  bool _showCongratulations = false;

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();
  }

  Future<void> _loadCheckboxState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _daysCompleted = List.generate(
        31,
            (index) =>
        _prefs.getBool('${widget.challengeId}/day_$index') ?? false,
      );
    });
  }

  Future<void> _saveCheckboxState(int index, bool value) async {
    await _prefs.setBool('${widget.challengeId}/day_$index', value);
  }

  bool _isAllCompleted() {
    return _daysCompleted.every((day) => day);
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You finished your saving challenge."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _daysCompleted = List.filled(31, false); // Reset checkboxes
                });
                for (int i = 0; i < _daysCompleted.length; i++) {
                  _saveCheckboxState(i, false); // Save the reset state
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text("Challenge Details"),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _daysCompleted = List.filled(31, true);
              });
              for (int i = 0; i < _daysCompleted.length; i++) {
                await _saveCheckboxState(i, true);
              }
              _showCongratulationsDialog(); // Show congratulatory message
            },
            child: Text(
              "Select All",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  _daysCompleted.length,
                      (index) => ListTile(
                    title: Text("Day ${index + 1}"),
                    trailing: Checkbox(
                      value: _daysCompleted[index],
                      onChanged: (value) {
                        setState(() {
                          _daysCompleted[index] = value ?? false;
                          _saveCheckboxState(index, value ?? false);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
