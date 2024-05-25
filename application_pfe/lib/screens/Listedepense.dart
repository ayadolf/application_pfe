import 'package:flutter/material.dart';
import '../Controllers/DepenseController.dart';
import '../models/Depense.dart';
import 'AddDepense.dart';
import 'editDepense.dart';

class Listedepense extends StatefulWidget {
  @override
  _ListedepensesState createState() => _ListedepensesState();
}

class _ListedepensesState extends State<Listedepense> {
  bool isFixedExpenseSelected = false;
  final DepenseController _depenseController = DepenseController();
  late Future<List<Depense>> futureDepenses;

  @override
  void initState() {
    super.initState();
    futureDepenses = _loadDepenses();
  }

  Future<List<Depense>> _loadDepenses() async {
    String category = isFixedExpenseSelected ? 'fixe' : 'variable';
    return _depenseController.getAllDepensesSortedByDate(category);
  }

  // Method to delete a Depense object
  Future<void> deleteDepense(String name, String date) async {
    print('Deleting depense with ID: $name');
    await _depenseController.deleteDepense(name, date);
    print('Depense deleted. Refreshing list...');
    setState(() {
      futureDepenses = _loadDepenses(); // Refresh the list after deletion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Expenses'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDepense()),
                );
              },
              child: const Text(
                "Add",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isFixedExpenseSelected ? Colors.blueAccent : Colors.blue[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isFixedExpenseSelected = true;
                            futureDepenses = _loadDepenses(); // Refresh expenses when button pressed
                          });
                        },
                        child: Text(
                          'Dépense Fixe',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: !isFixedExpenseSelected ? Colors.blueAccent : Colors.blue[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isFixedExpenseSelected = false;
                            futureDepenses = _loadDepenses(); // Refresh expenses when button pressed
                          });
                        },
                        child: Text(
                          'Dépense Variable',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 120,
            child: FutureBuilder<List<Depense>>(
              future: futureDepenses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final depenses = snapshot.data;
                  return ListView.builder(
                    itemCount: depenses?.length ?? 0,
                    itemBuilder: (context, index) {
                      final depense = depenses![index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                            depense.name ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date: ${depense.date ?? ''}"),
                              Text("Price: ${depense.amount ?? ''}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete Depense"),
                                        content: Text("Are you sure you want to delete this Depense?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop(); // Close the dialog
                                              if (depense.name != null) {
                                                await deleteDepense(depense.name, depense.date); // Delete the depense if ID is not null
                                              } else {
                                                // Handle case where ID is null
                                                print('Depense ID is null');
                                              }
                                            },
                                            child: Text("Delete"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  var editedDepense = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) {

                                          return EditDepense(depense: depense);
                                        }

                                    ),
                                  );

                                  // Check if the user actually edited the Depense object
                                  if (editedDepense != null) {
                                    // Update the Depense object in the database
                                    await updateDepenseInList(editedDepense);

                                    // Refresh the list after updating
                                    setState(() {
                                      futureDepenses = _loadDepenses();
                                    });
                                  }
                                },
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }



  Future<void> updateDepenseInList(Depense editedDepense) async {
    try {
      int result = await _depenseController.updateDepense(editedDepense);
      if (result > 0) {
        // Mise à jour réussie
        print('Dépense mise à jour avec succès.');
      } else
      {
        // Mise à jour échouée
        print('Échec de la mise à jour de la dépense.');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de la dépense: $e');
      // Gérer l'erreur si nécessaire
    }
  }
}