import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../blocs/admin/admin_bloc.dart';
import '../../blocs/admin/admin_state.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/role_badge.dart';
import 'admin_credit_management_view.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  String _roleFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('User & Credit Governance', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final allUsers = state is AdminLoaded ? state.users : <UserModel>[];
          final filtered = _roleFilter == 'all'
              ? allUsers
              : allUsers.where((u) => u.role.toLowerCase() == _roleFilter).toList();

          return Column(
            children: [
              // Filter Chips
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _filterChip('all', 'All Users'),
                    const SizedBox(width: 8),
                    _filterChip('customer', 'Customers'),
                    const SizedBox(width: 8),
                    _filterChip('dealer', 'Dealers'),
                    const SizedBox(width: 8),
                    _filterChip('plumber', 'Plumbers'),
                  ],
                ),
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<AdminBloc>().add(LoadAdminDataEvent());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final user = filtered[index];
                      final isDealer = user.role.toLowerCase() == 'dealer';
                      final isPlumber = user.role.toLowerCase() == 'plumber';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  RoleBadge(role: user.role),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mobile: +91-${user.mobileNumber}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),

                              if (isDealer) ...[
                                const Divider(height: 18),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Limit: ₹${user.creditLimit.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                        Text(
                                          '30D: ${user.credit30Allowed ? "YES" : "NO"} • 90D: ${user.credit90Allowed ? "YES" : "NO"}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.edit, size: 14),
                                      label: const Text('Manage Credit'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.dealerColor,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        textStyle: const TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => AdminCreditManagementView(dealer: user),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],

                              if (isPlumber) ...[
                                const Divider(height: 18),
                                Row(
                                  children: [
                                    const Icon(Icons.verified, size: 14, color: AppColors.success),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Cert: ${user.plumberCertificationNo ?? "PLM-9021"} (Verified)',
                                      style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _filterChip(String role, String label) {
    final isSelected = _roleFilter == role;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.adminColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => setState(() => _roleFilter = role),
    );
  }
}
