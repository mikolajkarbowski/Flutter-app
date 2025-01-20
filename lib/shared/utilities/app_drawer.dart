import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/service_locator.dart';
import '../../core/theme/app_theme.dart';
import '../../features/authentication/data/auth_service.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final List<String> _routes = ['HomePage', 'StatisticsPage'];

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: context.watch<NavigationState>().selectedIndex,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onDestinationSelected: (index) {
        context.read<NavigationState>().updateIndex(index);
        context.pop();
        context.goNamed(_routes[index]);
      },
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
          ),
          child: Text('Menu'),
        ),
        NavigationDrawerDestination(
            icon: Icon(Icons.list),
            selectedIcon: Icon(
              Icons.list,
              color: AppTheme.accentColor,
            ),
            label: Text('Decks')),
        NavigationDrawerDestination(
          icon: Icon(Icons.bar_chart),
          selectedIcon: Icon(
            Icons.bar_chart,
            color: AppTheme.accentColor,
          ),
          label: Text('Statistics'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            leading: Icon(Icons.logout),
            title: Text('Logout'),
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
