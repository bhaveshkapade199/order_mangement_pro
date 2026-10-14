import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'admin_reports_view.dart';
import 'admin_users_view.dart';
import 'admin_orders_view.dart';
import 'admin_zoho_sync_view.dart';

class AdminMainShell extends StatefulWidget {
  const AdminMainShell({super.key});

  @override
  State<AdminMainShell> createState() => _AdminMainShellState();
}

class _AdminMainShellState extends State<AdminMainShell> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    AdminReportsView(),
    AdminUsersView(),
    AdminOrdersView(),
    AdminZohoSyncView(),
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
        selectedItemColor: AppColors.adminColor,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Users & Credit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'All Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_alt_outlined),
            activeIcon: Icon(Icons.sync_alt),
            label: 'Zoho Sync',
          ),
        ],
      ),
    );
  }
}
