import 'package:flutter/material.dart';

class ReviewsErrorScreen extends StatelessWidget {
  final String message;

  const ReviewsErrorScreen({
    super.key,
    this.message = "Failed to load data.",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
