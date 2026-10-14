import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/admin/admin_bloc.dart';
import '../../blocs/admin/admin_state.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/primary_button.dart';

class AdminZohoSyncView extends StatelessWidget {
  const AdminZohoSyncView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Zoho Integration Center', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminLoaded && state.syncSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.syncSuccessMessage!),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is AdminFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Zoho Workbook Connection Status Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.cloud_sync, color: Colors.red, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Zoho Workbook Master',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Product_Inventory_Master.xlsx',
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'monospace'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'CONNECTED',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'This interface synchronizes product catalog items, retail prices, dealer wholesale prices, and real-time stock levels directly into the MongoDB catalog.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'Trigger Instant Zoho Workbook Sync',
                        icon: Icons.sync,
                        backgroundColor: AppColors.adminColor,
                        onPressed: () {
                          context.read<AdminBloc>().add(TriggerZohoSyncEvent());
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Zoho Enterprise Integration Architecture',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),

                _buildIntegrationCard(
                  title: '1. Dealer Mobile Verification (Zoho CRM)',
                  desc: 'Every dealer mobile number is queried against Zoho CRM Vendor/Contact directory before issuing login OTP.',
                  icon: Icons.phonelink_lock,
                ),
                const SizedBox(height: 10),
                _buildIntegrationCard(
                  title: '2. Catalog & Stock Ingestion (Zoho Sheet API)',
                  desc: 'Scheduled cron and webhook endpoints ingest workbook inventory rows to keep dealer stock levels in sync.',
                  icon: Icons.table_chart,
                ),
                const SizedBox(height: 10),
                _buildIntegrationCard(
                  title: '3. Credit Terms Governance (Zoho Books)',
                  desc: 'Approved credit days (30 days vs 90 days) and credit limits mirror Zoho Books vendor credit profiles.',
                  icon: Icons.account_balance,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntegrationCard({
    required String title,
    required String desc,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.adminColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
