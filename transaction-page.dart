import 'package:flutter/material.dart';

void main() {
  runApp(MoneyTransactionGame());
}

class MoneyTransactionGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Transaction Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFE0F7FA), // Light Teal Background
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1565C0), // Deep Blue AppBar
          centerTitle: true,
          elevation: 4,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: TransactionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int currentQuestionIndex = 0;
  List<int> selectedAmounts = [];

  final List<Map<String, dynamic>> notesAndCoins = [
    {'value': 1, 'label': '₹1', 'image': 'assets/images/1 coin.png'},
    {'value': 2, 'label': '₹2', 'image': 'assets/images/2 RS.png'},
    {'value': 5, 'label': '₹5', 'image': 'assets/images/5 coin.png'},
    {'value': 10, 'label': '₹10', 'image': 'assets/images/10 coin.png'},
    {'value': 20, 'label': '₹20', 'image': 'assets/images/20 coin.png'},
    {'value': 50, 'label': '₹50', 'image': 'assets/images/50 note.jpeg'},
  ];

  final List<Map<String, dynamic>> questions = [
    {
      'text': 'Mom gave Rs 50 to her 5 children. How many Rs will each child get?',
      'type': 'division',
      'total': 50,
      'children': 5,
    },
    {
      'text': 'Riya bought a banana for Rs 10.\nShe gave Rs 20.\nHow much will she get back?',
      'type': 'subtraction',
      'paid': 20,
      'price': 10,
    },
    {
      'text': "Aarnav's mother gave him Rs 100 to buy groceries worth Rs 30. How much money will be left with Aarnav?",
      'type': 'subtraction',
      'paid': 100,
      'price': 30,
    },
  ];

  void submitAnswer() {
    int correctAnswer = 0;
    final question = questions[currentQuestionIndex];

    if (question['type'] == 'division') {
      correctAnswer = (question['total'] / question['children']).round();
    } else if (question['type'] == 'subtraction') {
      correctAnswer = question['paid'] - question['price'];
    }

    int selectedTotal = selectedAmounts.fold(0, (sum, amount) => sum + amount);

    if (selectedTotal == correctAnswer) {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAmounts.clear();
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Congratulations! 🎉'),
            content: Text('You completed all questions!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentQuestionIndex = 0;
                    selectedAmounts.clear();
                  });
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wrong answer! Try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      setState(() {
        selectedAmounts.clear(); // reset on wrong answer
      });
    }
  }

  void resetSelection() {
    setState(() {
      selectedAmounts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Money Transaction Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  question['text'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Amount: ₹${selectedAmounts.fold(0, (sum, amount) => sum + amount)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: notesAndCoins.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = notesAndCoins[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAmounts.add(item['value']);
                      });
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item['image'],
                            height: 50,
                          ),
                          SizedBox(height: 8),
                          Text(
                            item['label'],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white, // Green submit button
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Submit Answer', style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                  onPressed: resetSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white, // Red reset button
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Reset', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

