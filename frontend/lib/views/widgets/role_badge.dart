import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;
    IconData icon;

    switch (role.toLowerCase()) {
      case 'dealer':
        bg = AppColors.dealerColor.withOpacity(0.12);
        text = AppColors.dealerColor;
        label = 'Verified Dealer';
        icon = Icons.storefront;
        break;
      case 'plumber':
        bg = AppColors.plumberColor.withOpacity(0.12);
        text = AppColors.plumberColor;
        label = 'Certified Plumber';
        icon = Icons.handyman;
        break;
      case 'admin':
        bg = AppColors.adminColor.withOpacity(0.12);
        text = AppColors.adminColor;
        label = 'System Admin';
        icon = Icons.admin_panel_settings;
        break;
      case 'customer':
      default:
        bg = AppColors.customerColor.withOpacity(0.12);
        text = AppColors.customerColor;
        label = 'Retail Customer';
        icon = Icons.person;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: text.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
