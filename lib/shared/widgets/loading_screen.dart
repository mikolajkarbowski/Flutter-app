import 'package:flutter/material.dart';
import 'package:memo_deck/core/theme/app_theme.dart';
import 'package:memo_deck/shared/widgets/loading_indicator.dart';

class LoadingScreen extends StatelessWidget {

  const LoadingScreen({
    super.key,
    this.message = 'Loading...',
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingIndicator(),
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
