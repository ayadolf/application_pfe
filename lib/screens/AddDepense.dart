import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Depense.dart';
import '../utils/Depensedb_helper.dart';
import '../screens/Listedepense.dart';

class AddDepense extends StatefulWidget {
  const AddDepense({Key? key}) : super(key: key);

  @override
  State<AddDepense> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<AddDepense> {
  late TextEditingController _title = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  DateTime? _date;
  String _selectedCategory = 'variable';

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

  _addExpense() {
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
            content: Text('Depense added successfully. Do you want to continue?', style: TextStyle(color: Colors.black)),
            actions: [

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Listedepense())); // Redirige vers la page Listedepense
                },
                child: Text('OK', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );

        // Clear the text controllers and reset the date and category
        _title.clear();
        _amount.clear();
        _note.clear();
        setState(() {
          _date = null;
          _selectedCategory = 'fixe';
        });
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
