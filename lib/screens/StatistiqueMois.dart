import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../Controllers/DepenseController.dart';
import '../models/Depense.dart';

class StatistiqueMois extends StatefulWidget {
  @override
  _TotalChartState createState() => _TotalChartState();
}

class _TotalChartState extends State<StatistiqueMois> {
  final DepenseController _depenseController = DepenseController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Expenses Chart'),
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: FutureBuilder<List<CategoryData>>(
          future: _loadCategoriesData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final categories = snapshot.data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildChart(categories),
                  const SizedBox(height: 20),
                  ...categories.map((category) => _buildExpenseCard(category)),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<CategoryData>> _loadCategoriesData() async {
    List<CategoryData> categories = [];
    DateTime now = DateTime.now();
    int currentMonth = now.month;

    for (int month = 1; month <= currentMonth; month++) {
      List<Depense> monthDepenses = await _depenseController.getDepensesForMonth(month);
      double monthTotal = _calculateTotalExpenses(monthDepenses);

      String monthName = DateFormat('MMMM').format(DateTime(now.year, month));
      categories.add(CategoryData(title: monthName, totalAmount: monthTotal, color: _getMonthColor(month)));
    }

    return categories;
  }

  double _calculateTotalExpenses(List<Depense> depenses) {
    return depenses.fold(0.0, (sum, depense) => sum + depense.getPrix);
  }

  Color _getMonthColor(int month) {
    switch (month) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.grey;
      case 5:
        return Colors.orange;
      case 6:
        return Colors.purple;
      case 7:
        return Colors.teal;
      case 8:
        return Colors.indigo;
      case 9:
        return Colors.brown;
      case 10:
        return Colors.pink;
      case 11:
        return Colors.cyan;
      case 12:
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
  Widget _buildChart(List<CategoryData> categories) {
    final total = categories.fold(0.0, (sum, category) => sum + category.totalAmount);
    return Expanded(
      flex: 2,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: total, // La hauteur maximale du graphique est définie sur le total des dépenses
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: categories
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.totalAmount,
                  color: entry.value.color,
                  width: 30, // Largeur de la barre (augmentez cette valeur pour des barres plus larges)

                ),
              ],
            ),
          )
              .toList(),
        ),
      ),
    );

  }


  Widget _buildExpenseCard(CategoryData category) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(category.title),
        subtitle: Text('Total Amount: ${NumberFormat.currency(locale: 'en_IN', symbol: 'dh').format(category.totalAmount)}'),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: category.color,
          ),
        ),
      ),
    );
  }
}

class CategoryData {
  final String title;
  final double totalAmount;
  final Color color;

  const CategoryData({required this.title, required this.totalAmount, required this.color});
}