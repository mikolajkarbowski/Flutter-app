import 'package:flutter/material.dart';

class GradientBackgroundWrapper extends StatelessWidget {
  const GradientBackgroundWrapper({this.child, super.key});

  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4637B3), Color(0xffde62c7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
