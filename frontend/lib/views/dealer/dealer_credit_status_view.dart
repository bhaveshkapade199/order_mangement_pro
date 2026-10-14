import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../core/constants/app_colors.dart';

class DealerCreditStatusView extends StatelessWidget {
  const DealerCreditStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Credit Facility & Eligibility', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          final creditLimit = user?.creditLimit ?? 250000.0;
          final creditUsed = user?.creditUsed ?? 45000.0;
          final available = creditLimit - creditUsed;
          final credit30 = user?.credit30Allowed ?? true;
          final credit90 = user?.credit90Allowed ?? true;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Credit Health Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Credit Allocation', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(
                        '₹${creditLimit.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.dealerColor),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Utilized Exposure', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              const SizedBox(height: 2),
                              Text('₹${creditUsed.toStringAsFixed(0)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.error)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Remaining Headroom', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              const SizedBox(height: 2),
                              Text('₹${available.toStringAsFixed(0)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.success)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (creditUsed / creditLimit).clamp(0.0, 1.0),
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.dealerColor),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Credit Term Approvals',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),

                // 30 Days Credit Term Status
                _buildTermCard(
                  title: '30-Day Commercial Credit',
                  description: 'Payment settlement expected within 30 days of shipment receipt.',
                  isActive: credit30,
                  statusText: credit30 ? 'Active & Approved' : 'Inactive',
                  icon: Icons.calendar_month,
                ),

                const SizedBox(height: 12),

                // 90 Days Credit Term Status
                _buildTermCard(
                  title: '90-Day Extended Credit (Tier-1 Dealers)',
                  description: 'Extended revolving credit for verified master stocking dealers based on annual procurement turnover.',
                  isActive: credit90,
                  statusText: credit90 ? 'Tier-1 Approved' : 'Restricted (Admin Permission Required)',
                  icon: Icons.verified_user,
                ),

                const SizedBox(height: 20),

                // Zoho Linkage Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.link, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text('Zoho Account Synchronization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your credit limit and approval status are dynamically synced with Zoho CRM account ID: ${user?.zohoContactId ?? "ZC-DL-9081"}.',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTermCard({
    required String title,
    required String description,
    required bool isActive,
    required String statusText,
    required IconData icon,
  }) {
    final color = isActive ? AppColors.success : AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isActive ? color.withOpacity(0.3) : AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
