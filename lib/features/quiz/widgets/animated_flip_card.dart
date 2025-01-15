import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedFlipCard extends StatefulWidget {
  const AnimatedFlipCard({super.key});

  @override
  State<StatefulWidget> createState() => _AnimatedFlipCardState();
}

class _AnimatedFlipCardState extends State<AnimatedFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _flipCard,
        child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final angle = _animation.value * pi;
              final isFrontVisible = angle <= pi / 2 || angle >= pi * 3 / 2;
              return Transform(
                transform: Matrix4.rotationY(angle),
                alignment: Alignment.center,
                child: isFrontVisible
                    ? _buildCard('question', Colors.red)
                    : Transform(
                        transform: Matrix4.rotationY(pi),
                        alignment: Alignment.center,
                        child: _buildCard(
                          'answer',
                          Colors.blue,
                        ),
                      ),
              );
            }),
      ),
    );
  }

  void _flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isFront = !isFront;
  }

  Widget _buildCard(String text, Color color) {
    return Card(
      color: color,
      margin: EdgeInsets.all(16),
      child: Center(
        child: Text(
          text,
        ),
      ),
    );
  }
}
