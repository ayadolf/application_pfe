import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Defis.dart';
import '../utils/Defisdb_helper.dart';
import 'ChallengeDetailsScreen.dart';
import 'CreateChallenge.dart';

class ChallengeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Defisdb_helper dbHelper = Defisdb_helper();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          shadowColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Challenges",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateChallenge()),
                  );
                },
                child: const Text(
                  "Add",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengeDetailsScreen(
                        title: 'Challenge saving 300 dh',
                        date: '22 juillet 2024 AU 22 août 2024',
                        amount: '10 dh',
                      ),
                    ),
                  );
                },
                child: ChallengeCard(
                  title: 'Challenge saving 300 dh',
                  date: '22 juillet 2024 AU 22 août 2024',
                  amount: '10 dh',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengeDetailsScreen(
                        title: 'Challenge saving 900 dh',
                        date: 'Click to start your new challenge.',
                        amount: '30 dh',
                      ),
                    ),
                  );
                },
                child: ChallengeCard(
                  title: 'Challenge saving 900 dh',
                  date: 'Click to start your new challenge.',
                  amount: '30 dh',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengeDetailsScreen(
                        title: 'Challenge saving 3000 dh',
                        date: 'Click to start your new challenge.',
                        amount: '100 dh',
                      ),
                    ),
                  );
                },
                child: ChallengeCard(
                  title: 'Challenge saving 3000 dh',
                  date: 'Click to start your new challenge.',
                  amount: '100 dh',
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    color: Colors.transparent,
                    child: Text(
                      ' My special challenges :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      FutureBuilder<List<Defis>>(
                        future: dbHelper.getDefis(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<Defis>? defis = snapshot.data;
                            if (defis != null && defis.isNotEmpty) {
                              return Column(
                                children: defis.map((defi) {
                                  double amountPerDay = defi.montant / 30;
                                  int amountPerDayInt = amountPerDay.toInt();
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChallengeDetailsScreen(
                                            title: defi.nom,
                                            date: 'Click to start your own challenge.',
                                            amount: '$amountPerDayInt dh',
                                          ),
                                        ),
                                      );
                                    },
                                    child: ChallengeCard(
                                      title: defi.nom,
                                      date: 'Click to start your own challenge.',
                                      amount: '$amountPerDayInt dh',
                                    ),
                                  );
                                }).toList(),
                              );
                            } else {
                              return Text('No challenge available');
                            }
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Challenge(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Challenge extends StatefulWidget {
  const Challenge({Key? key}) : super(key: key);

  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  late DateTime _selectedDate;
  late int _indexOfFirstDayMonth;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _indexOfFirstDayMonth = getIndexOfFirstDayInMonth(_selectedDate);
    _selectedIndex = _indexOfFirstDayMonth + DateTime.now().day - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double lineWidth = (constraints.maxWidth - 100) / 2;
              return Row(
                children: [
                  Container(
                    height: 2,
                    width: lineWidth,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${DateFormat('MMMM yyyy').format(_selectedDate)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 2,
                    width: lineWidth,
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 10),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: List.generate(
                  daysOfWeek.length,
                      (index) => TableCell(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.grey[300] : Colors.grey[300],
                        borderRadius: BorderRadius.horizontal(
                          left: index == 0 ? Radius.circular(4) : Radius.zero,
                          right: index == daysOfWeek.length - 1 ? Radius.circular(4) : Radius.zero,
                        ),
                      ),
                      child: Text(
                        daysOfWeek[index],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ...List.generate(
                5,
                    (rowIndex) => TableRow(
                  children: List.generate(
                    7,
                        (columnIndex) {
                      final int index = rowIndex * 7 + columnIndex;
                      final int dayOfMonth = index - _indexOfFirstDayMonth + 1;
                      final bool isWithinMonth = dayOfMonth > 0 &&
                          dayOfMonth <= listOfDatesInMonth(_selectedDate).length;
                      final bool isSelected = index == _selectedIndex;
                      return TableCell(
                        child: GestureDetector(
                          onTap: () {
                            if (isWithinMonth) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : (rowIndex % 2 == 0 ? Colors.lightBlue[100] : Colors.blue[200]),
                              borderRadius: BorderRadius.horizontal(
                                left: columnIndex == 0 ? Radius.circular(4) : Radius.zero,
                                right: columnIndex == 6 ? Radius.circular(4) : Radius.zero,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  isWithinMonth ? '$dayOfMonth' : '',
                                  style: TextStyle(
                                    color: isSelected ? Color(0xFF94C3F6) : Colors.white,
                                    fontSize: 17,
                                    fontWeight: columnIndex == 6 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                  height: 1,
                                  color: Colors.white,
                                ),
                                Container(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<int> listOfDatesInMonth(DateTime currentDate) {
  final selectedMonthFirstDay = DateTime(currentDate.year, currentDate.month, 1);
  final nextMonthFirstDay = DateTime(selectedMonthFirstDay.year, selectedMonthFirstDay.month + 1, selectedMonthFirstDay.day);
  final totalDays = nextMonthFirstDay.difference(selectedMonthFirstDay).inDays;

  return List<int>.generate(totalDays, (i) => i + 1);
}

int getIndexOfFirstDayInMonth(DateTime currentDate) {
  final selectedMonthFirstDay = DateTime(currentDate.year, currentDate.month, 1);
  final day = selectedMonthFirstDay.weekday;

  return (day + 6) % 7;
}

final List<String> daysOfWeek = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun",
];

class ChallengeCard extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  const ChallengeCard({
    Key? key,
    required this.title,
    required this.date,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.currency_exchange,
              color: Colors.grey,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(date),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
