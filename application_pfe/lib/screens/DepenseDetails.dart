import 'package:flutter/material.dart';
import 'package:application_pfe/models/Depense.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final Depense expense;

  const ExpenseDetailScreen({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Detail'),
        backgroundColor: Colors.blue[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          margin: EdgeInsets.all(8),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              'Expense Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              expense.name,
              style: TextStyle(fontSize: 16),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
