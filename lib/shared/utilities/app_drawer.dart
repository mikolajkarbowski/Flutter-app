import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/service_locator.dart';
import '../../core/theme/app_theme.dart';
import '../../features/authentication/data/auth_service.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final List<String> _routes = ['HomePage', 'BrowserPage', 'StatisticsPage'];

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: context.watch<NavigationState>().selectedIndex,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onDestinationSelected: (index) {
        context.read<NavigationState>().updateIndex(index);
        context..pop()
        ..goNamed(_routes[index]);
      },
      children: [
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: AppTheme.accentColor,
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.purple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          accountEmail: Text(serviceLocator<AuthService>().userEmail),
          accountName: const Text('MemoDeck'),
          currentAccountPicture:
              Lottie.asset('assets/animations/avatar_animation.json'),
        ),
        const NavigationDrawerDestination(
            icon: Icon(Icons.list),
            selectedIcon: Icon(
              Icons.list,
              color: AppTheme.accentColor,
            ),
            label: Text('Decks'),),
        const NavigationDrawerDestination(
            icon: Icon(Icons.copy),
            selectedIcon: Icon(
              Icons.copy,
              color: AppTheme.accentColor,
            ),
            label: Text('Card browser'),),
        const NavigationDrawerDestination(
          icon: Icon(Icons.bar_chart),
          selectedIcon: Icon(
            Icons.bar_chart,
            color: AppTheme.accentColor,
          ),
          label: Text('Statistics'),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              serviceLocator<AuthService>().signOut();
              context.goNamed('SplashPage');
            },
          ),
        ),
      ],
    );
  }
}

class NavigationState extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
