import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PlumberNotificationsView extends StatelessWidget {
  const PlumberNotificationsView({super.key});

  final List<Map<String, dynamic>> _alerts = const [
    {
      'title': 'New Service Activity Assigned',
      'message': 'You have been assigned to pipeline leakage rectification at Flat 302, Palm Heights.',
      'time': '30m ago',
      'icon': Icons.assignment,
      'color': AppColors.info,
    },
    {
      'title': 'Zoho Plumber Credential Verified',
      'message': 'Your annual government plumbing certification PLM-GOVT-2024-912 was successfully verified.',
      'time': '1d ago',
      'icon': Icons.verified,
      'color': AppColors.success,
    },
    {
      'title': 'CPVC Technical Manual Updated',
      'message': 'ASTM flow velocity reference chart has been updated for high pressure pipes.',
      'time': '2d ago',
      'icon': Icons.menu_book,
      'color': AppColors.plumberColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications & Alerts', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _alerts.length,
        itemBuilder: (context, index) {
          final alert = _alerts[index];
          final color = alert['color'] as Color;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.border),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(alert['icon'] as IconData, color: color, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              alert['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              alert['time'],
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alert['message'],
                          style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
