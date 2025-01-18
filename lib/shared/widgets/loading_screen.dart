import 'package:flutter/material.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/shared/widgets/loading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({
    super.key,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingIndicator(),
          const SizedBox(height: 20),
          Text(
            message,
            style: AppTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
