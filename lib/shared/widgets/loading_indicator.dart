import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 60,
          ),
          child: const AspectRatio(
            aspectRatio: 1 / 1,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
