import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../Controllers/DepenseController.dart';
import '../models/Depense.dart';
import 'RapportMobile.dart';

class Rapport extends StatefulWidget {
  @override
  _RapportState createState() => _RapportState();
}

class _RapportState extends State<Rapport> {
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  List<Depense> _expenses = [];

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text('Géneration des Rapport '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _monthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Month (1-12)'),
            ),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Year'),
            ),
            SizedBox(height: 16.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: _fetchExpenses,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue[100], // Text color
              padding: EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
            ),
            child: Text(
              'Display',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ),

            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];
                  return ListTile(
                    title: Text(expense.name ?? ''),
                    subtitle: Text('${expense.amount} dh - ${expense.date}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPDF,backgroundColor: Colors.blue[100],
        child: Icon(Icons.picture_as_pdf ,color: Colors.blue[300],),
      ),
    );
  }

  Future<void> _fetchExpenses() async {
    final int? month = int.tryParse(_monthController.text);
    final int? year = int.tryParse(_yearController.text);
    if (month != null && year != null) {
      DepenseController _depenseController = DepenseController();
      List<Depense> expenses = await _depenseController.getDepensesForMonthAndYear(month, year);
      setState(() {
        _expenses = expenses;
      });
      if (expenses.isEmpty) {
        // Show message that there are no expenses for the entered date
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No Expenses'),
              content: Text('There are no expenses for the selected month and year.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show error message or handle invalid input
    }
  }


  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    // Fetch expense data for the selected month and year
    final int? month = int.tryParse(_monthController.text);
    final int? year = int.tryParse(_yearController.text);
    if (month != null && year != null) {
      List<Depense> expenses = await _loadDepensesForMonthAndYear(month, year);

      // Adjust these values to control logo position and size
      final double logoX = 0; // Adjust X coordinate for horizontal placement
      final double logoY = 0; // Adjust Y coordinate for vertical placement (usually 0 for top)
      final double logoWidth = 70; // Adjust width of the logo
      final double logoHeight = 70; // Adjust height of the logo

      // Space between logo and text (adjust as needed)
      final double textY = logoY + logoHeight + 20; // Place the text below the logo

      // Ajout du texte et du logo
      // Dessiner le logo
      final Uint8List logoData = await _loadLogoData();
      final PdfBitmap logo = PdfBitmap(logoData);
      final imageRect = Rect.fromLTWH(logoX, logoY, logoWidth, logoHeight);
      page.graphics.drawImage(logo, imageRect);

      // Dessiner le texte sous le logo
      final String titleText = 'Expenses Report';
      final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 24);
      page.graphics.drawString(
        titleText,
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(logoX, textY, page.getClientSize().width, titleFont.height),
      );

      // Calculate total amount
      double totalAmount = calculateTotalAmount(expenses);

      // Start Y position for expenses data
      double currentY = textY + titleFont.height + 50;

      // Draw table headers
      _drawTable(page, currentY, ['Nom', 'Montant', 'Date']);

      currentY += 20; // Move down after header

      // Draw table rows
      for (var expense in expenses) {
        final String expenseName = expense.name ?? '';
        final double expenseAmount = expense.amount ?? 0.0;
        final String expenseDate = expense.date ?? '';

        _drawTable(page, currentY, [expenseName, '$expenseAmount dh', expenseDate]);

        currentY += 20; // Move down after row
      }

      // Draw total amount text
      final PdfFont totalFont = PdfStandardFont(PdfFontFamily.helvetica, 20);
      final String totalText = 'Total amount of expense: $totalAmount dh';
      page.graphics.drawString(
        totalText,
        totalFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(logoX, currentY + 20, page.getClientSize().width, totalFont.height),
      );

      try {
        final bytes = await document.save();
        saveAndLaunchFile(bytes, 'expenses rapport.pdf'); // Replace with your function to save and launch PDF
      } catch (error) {
        print("Error generating PDF: $error");
      } finally {
        document.dispose();
      }
    }
  }

  Future<List<Depense>> _loadDepensesForMonthAndYear(int month, int year) async {
    DepenseController _depenseController = DepenseController();
    return _depenseController.getDepensesForMonthAndYear(month, year);
  }

  // Fonction pour charger les données du logo depuis le bundle d'application
  Future<Uint8List> _loadLogoData() async {
    final ByteData data = await rootBundle.load('images/logo.jpg'); // Remplacez 'assets/logo.png' par le chemin de votre logo
    return Uint8List.view(data.buffer);
  }

  // Fonction pour calculer le prix total des dépenses
  double calculateTotalAmount(List<Depense> expenses) {
    double total = 0;
    for (var expense in expenses) {
      total += expense.amount ?? 0.0;
    }
    return total;
  }

  void _drawTable(PdfPage page, double startY, List<String> rowData) {
    const double cellWidth = 200; // Largeur de chaque cellule
    final double cellHeight = 30; // Hauteur de chaque cellule
    final PdfFont cellFont = PdfStandardFont(PdfFontFamily.helvetica, 20); // Police de la cellule

    PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0)); // Couleur du texte

    // Dessinez chaque cellule dans la ligne
    for (int i = 0; i < rowData.length; i++) {
      String cellValue = rowData[i];
      // Vérifiez si c'est la cellule du montant
      if (i == 1) {
        double amountX = i * cellWidth;
        double amountY = startY;
        page.graphics.drawString(
          cellValue,
          cellFont,
          brush: brush,
          bounds: Rect.fromLTWH(amountX, amountY, cellWidth, cellHeight),
        );
      } else {
        double cellX = i * cellWidth;
        double cellY = startY;
        page.graphics.drawString(
          cellValue,
          cellFont,
          brush: brush,
          bounds: Rect.fromLTWH(cellX, cellY, cellWidth, cellHeight),
        );
      }
    }
  }
}