import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizEndScreen extends StatelessWidget {
  const QuizEndScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Colors.green,
          ),
          const SizedBox(height: 20),
          const Text(
            'Well done!\n'
            ' There are no cards left to review for now.\n'
            ' Check back soon for more practice.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.goNamed('HomePage'),
            child: const Text('Back to Main Page'),
          ),
        ],
      ),
    );
  }
}
