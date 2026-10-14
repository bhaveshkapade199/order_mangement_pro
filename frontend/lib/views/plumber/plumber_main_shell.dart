import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'plumber_dashboard_view.dart';
import 'plumber_tasks_view.dart';
import 'plumber_products_view.dart';
import 'plumber_notifications_view.dart';

class PlumberMainShell extends StatefulWidget {
  const PlumberMainShell({super.key});

  @override
  State<PlumberMainShell> createState() => _PlumberMainShellState();
}

class _PlumberMainShellState extends State<PlumberMainShell> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    PlumberDashboardView(),
    PlumberTasksView(),
    PlumberProductsView(),
    PlumberNotificationsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.plumberColor,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.construction_outlined),
            activeIcon: Icon(Icons.construction),
            label: 'Supplies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}
