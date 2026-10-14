import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/plumber/plumber_bloc.dart';
import '../../blocs/plumber/plumber_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/role_badge.dart';
import '../auth/role_selection_view.dart';
import 'plumber_tasks_view.dart';

class PlumberDashboardView extends StatefulWidget {
  const PlumberDashboardView({super.key});

  @override
  State<PlumberDashboardView> createState() => _PlumberDashboardViewState();
}

class _PlumberDashboardViewState extends State<PlumberDashboardView> {
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Plumber Workspace',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Service Activities & Field Operations',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: RoleBadge(role: AppConstants.rolePlumber),
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
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final user = authState is AuthAuthenticated ? authState.user : null;

          return BlocBuilder<PlumberBloc, PlumberState>(
            builder: (context, plumberState) {
              final stats = plumberState is PlumberLoaded ? plumberState.summary['stats'] : null;
              final assignedCount = stats != null ? stats['assigned'] ?? 1 : 1;
              final inProgressCount = stats != null ? stats['inProgress'] ?? 1 : 1;
              final completedCount = stats != null ? stats['completed'] ?? 12 : 12;
              final earnings = stats != null ? stats['totalEarningsThisMonth'] ?? 9000 : 9000;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plumber Certified Profile Header
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.plumberColor, Color(0xFFF38A71)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.plumberColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.verified, size: 14, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      'Certified & Verified Plumber',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.9 (84 reviews)',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            user?.name ?? 'Ramesh Sharma',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cert ID: ${user?.plumberCertificationNo ?? "PLM-GOVT-2024-912"} • +91-${user?.mobileNumber ?? "9888800001"}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 14),

                          // Availability Switch
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _isAvailable ? AppColors.success : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isAvailable ? 'Available for New Service Calls' : 'Offline / Busy',
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: _isAvailable,
                                  onChanged: (val) => setState(() => _isAvailable = val),
                                  activeColor: Colors.white,
                                  activeTrackColor: AppColors.success,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Metrics Grid
                    Row(
                      children: [
                        _buildStatCard(
                          title: 'Assigned',
                          count: '$assignedCount',
                          subtitle: 'Pending visit',
                          color: AppColors.info,
                          icon: Icons.assignment_late,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          title: 'In Progress',
                          count: '$inProgressCount',
                          subtitle: 'Active now',
                          color: AppColors.warning,
                          icon: Icons.pending_actions,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          title: 'Completed',
                          count: '$completedCount',
                          subtitle: 'This month',
                          color: AppColors.success,
                          icon: Icons.task_alt,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Earnings Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.monetization_on, color: AppColors.secondary, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Service Payouts Accumulated', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${earnings.toString()}',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Direct Bank Deposit',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Active Activities Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Assigned Field Activities',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const PlumberTasksView()),
                            );
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.plumberColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Pre-seeded Active Job Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'IN PROGRESS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ),
                              const Text('Task: TSK-PLM-702', style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppColors.textMuted)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Basin Mixer Tap Fitting & Seal Check',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Customer: Sanjay Deshmukh • +91-9822001122\nAddress: Villa 14, Royal Palms, Mumbai 400065',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle_outline, size: 16),
                              label: const Text('Mark Activity Completed'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.plumberColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Activity marked completed with completion remarks!')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
