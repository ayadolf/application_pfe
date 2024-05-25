import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Defis.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  final Defis defis;

  const ChallengeDetailsScreen({Key? key, required this.defis}) : super(key: key);

  @override
  _ChallengeDetailsScreenState createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  late SharedPreferences _prefs;
  late String _challengeKey;
  late List<bool> _daysCompleted;

  @override
  void initState() {
    super.initState();
    _challengeKey = '${widget.defis.idDefis}';
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
