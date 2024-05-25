import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Depense.dart';
import '../utils/Depensedb_helper.dart';
import 'Listedepense.dart';

class EditDepense extends StatefulWidget {
  final Depense depense;

  const EditDepense({Key? key, required this.depense}) : super(key: key);

  @override
  _EditDepenseState createState() => _EditDepenseState();
}

class _EditDepenseState extends State<EditDepense> {
  late TextEditingController _title;
  late TextEditingController _amount;
  late TextEditingController _note;
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.depense.name);
    _amount = TextEditingController(text: widget.depense.amount.toString());
    _note = TextEditingController(text: widget.depense.note);
    _date = DateFormat('yyyy-MM-dd').parse(widget.depense.date);
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
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

  _updateExpense() {
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

    final updatedDepense = Depense(
      name: name,
      amount: amount,
      date: date,
      note: note,
      categorie: 'variable', // Assign 'variable' value to categorie after modification
    );

    final dbHelper = Depensedb_helper();
    dbHelper.updateDepense(updatedDepense).then((value) {
      if (value > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Expense updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        _redirectToList(); // Rediriger vers la liste des dépenses après mise à jour
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update expense. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _redirectToList() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Listedepense()), // Remplacez par le nom de votre widget de liste des dépenses
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Expense',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue[100],
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
                      suffixIcon: Icon(Icons.track_changes),
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
                      suffixIcon: Icon(Icons.attach_money),
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
                    height: 200.0,
                    child: TextField(
                      controller: _note,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Write a note here',
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.note_outlined),
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
                onPressed: _updateExpense,
                color: Colors.blue[200],
                textColor: Colors.white,
                height: 60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.update),
                    SizedBox(width: 15.0),
                    Text(
                      'Update expense',
                      style: TextStyle(fontSize: 20),
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
