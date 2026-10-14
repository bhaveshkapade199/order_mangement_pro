import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'dealer_home_view.dart';
import 'dealer_catalog_view.dart';
import 'dealer_credit_status_view.dart';
import '../customer/order_tracking_view.dart';

class DealerMainShell extends StatefulWidget {
  const DealerMainShell({super.key});

  @override
  State<DealerMainShell> createState() => _DealerMainShellState();
}

class _DealerMainShellState extends State<DealerMainShell> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    DealerHomeView(),
    DealerCatalogView(),
    DealerCreditStatusView(),
    CustomerOrdersView(),
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
        selectedItemColor: AppColors.dealerColor,
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
            icon: Icon(Icons.inventory_outlined),
            activeIcon: Icon(Icons.inventory),
            label: 'Wholesale',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            activeIcon: Icon(Icons.credit_card),
            label: 'Credit Terms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
