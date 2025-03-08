import 'package:flutter/material.dart';
import 'package:memo_deck/features/activity_tracker/widgets/daily_stats.dart';
import 'package:memo_deck/features/activity_tracker/widgets/reviews.dart';
import 'package:memo_deck/shared/utilities/app_drawer.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          padding: const EdgeInsets.only(top: 5),
          children: const[
            DailyStats(),
            Reviews(),
          ],
        ),
      ),
    );
  }
}
