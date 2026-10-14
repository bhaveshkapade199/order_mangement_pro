import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/admin/admin_bloc.dart';
import '../../blocs/admin/admin_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/role_badge.dart';
import '../auth/role_selection_view.dart';

class AdminReportsView extends StatefulWidget {
  const AdminReportsView({super.key});

  @override
  State<AdminReportsView> createState() => _AdminReportsViewState();
}

class _AdminReportsViewState extends State<AdminReportsView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadAdminDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Admin Governance Portal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Commercial Reports & Credit Risk',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: RoleBadge(role: AppConstants.roleAdmin),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary, size: 20),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RoleSelectionView()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = state is AdminLoaded ? state.reports : null;
          final userMetrics = reports?['userMetrics'];
          final salesMetrics = reports?['salesMetrics'];

          final totalCustomers = userMetrics?['totalCustomers'] ?? 1;
          final totalDealers = userMetrics?['totalDealers'] ?? 3;
          final totalPlumbers = userMetrics?['totalPlumbers'] ?? 1;

          final totalRevenue = salesMetrics?['totalGrossRevenue'] ?? 184500;
          final upfrontCash = salesMetrics?['upfrontCashCollected'] ?? 9912;
          final credit30 = salesMetrics?['credit30DaysExposure'] ?? 45000;
          final credit90 = salesMetrics?['credit90DaysExposure'] ?? 129588;
          final totalCredit = salesMetrics?['totalCreditOutstanding'] ?? (credit30 + credit90);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminBloc>().add(LoadAdminDataEvent());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Revenue & Turnover Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.adminColor, Color(0xFF3D6978)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.adminColor.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Gross Revenue',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹$totalRevenue',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Direct Cash / UPI', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                  const SizedBox(height: 2),
                                  Text('₹$upfrontCash', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                            ),
                            Container(width: 1, height: 30, color: Colors.white24),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Total Credit Exposure', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                  const SizedBox(height: 2),
                                  Text('₹$totalCredit', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'User Roles Distribution',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _buildMetricTile(
                        label: 'Customers',
                        count: '$totalCustomers',
                        color: AppColors.customerColor,
                        icon: Icons.person,
                      ),
                      const SizedBox(width: 10),
                      _buildMetricTile(
                        label: 'Dealers',
                        count: '$totalDealers',
                        color: AppColors.dealerColor,
                        icon: Icons.storefront,
                      ),
                      const SizedBox(width: 10),
                      _buildMetricTile(
                        label: 'Plumbers',
                        count: '$totalPlumbers',
                        color: AppColors.plumberColor,
                        icon: Icons.handyman,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Commercial Credit Exposure Breakdown',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),

                  // Credit 30 vs 90 Breakdown Cards
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.calendar_today, color: AppColors.secondary, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('30-Day Revolving Credit Exposure', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text('Outstanding invoices within 30-day grace', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Text('₹$credit30', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.dealerColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.verified, color: AppColors.dealerColor, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('90-Day Extended Credit Exposure', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text('Tier-1 Approved Dealers facility', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Text('₹$credit90', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.dealerColor)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
