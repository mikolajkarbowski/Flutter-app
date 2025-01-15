import 'package:flutter/material.dart';
import 'package:memo_deck/features/quiz/widgets/animated_flip_card.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key, required this.deckId});

  final String deckId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: AnimatedFlipCard(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // Obsługa edycji
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    // Obsługa obrotu karty
                  },
                  child: Icon(Icons.refresh, color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.white),
                  onPressed: () {
                    // Obsługa odtwarzania
                  },
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Obsługa "Hard"
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    'Hard',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Obsługa "Good"
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(
                    'Good',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Obsługa "Easy"
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    'Easy',
                    style: TextStyle(color: Colors.white),
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
