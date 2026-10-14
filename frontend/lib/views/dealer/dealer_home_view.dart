import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/role_badge.dart';
import '../auth/role_selection_view.dart';
import 'dealer_catalog_view.dart';
import 'dealer_credit_status_view.dart';

class DealerHomeView extends StatelessWidget {
  const DealerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Dealer Portal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Commercial Procurement & Credit Management',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: RoleBadge(role: AppConstants.roleDealer),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: AppColors.textSecondary,
              size: 20,
            ),
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
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          final availableCredit = user != null
              ? (user.creditLimit - user.creditUsed)
              : 205000.0;
          final creditLimit = user?.creditLimit ?? 250000.0;
          final creditUsed = user?.creditUsed ?? 45000.0;
          final credit30 = user?.credit30Allowed ?? true;
          final credit90 = user?.credit90Allowed ?? true;
          final zohoId = user?.zohoContactId ?? 'ZC-DL-9081';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dealer Identity Card with Zoho Verified Stamp
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.dealerColor, Color(0xFF8B2FC9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dealerColor.withOpacity(0.2),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Zoho CRM Verified Partner',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            zohoId,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user?.name ?? 'Apex Plumbing Supplies & Hardware',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'GSTIN: 27AABCP1234F1Z8 • Phone: +91-${user?.mobileNumber ?? "9876543210"}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Credit Line Card
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
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
                          const Text(
                            'Commercial Credit Facility',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const DealerCreditStatusView(),
                                ),
                              );
                            },
                            child: const Text(
                              'View Terms',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dealerColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Available Credit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '₹${availableCredit.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.dealerColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Total Limit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '₹${creditLimit.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: creditLimit > 0
                              ? (creditUsed / creditLimit).clamp(0.0, 1.0)
                              : 0,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.dealerColor,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 30 Days and 90 Days Badges
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: credit30
                                    ? AppColors.success.withOpacity(0.08)
                                    : AppColors.border,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: credit30
                                      ? AppColors.success.withOpacity(0.3)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    credit30
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    size: 16,
                                    color: credit30
                                        ? AppColors.success
                                        : AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '30-Day Credit: ACTIVE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: -0,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: credit90
                                    ? AppColors.dealerColor.withOpacity(0.08)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: credit90
                                      ? AppColors.dealerColor.withOpacity(0.3)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    credit90
                                        ? Icons.verified
                                        : Icons.lock_outline,
                                    size: 16,
                                    color: credit90
                                        ? AppColors.dealerColor
                                        : AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    credit90
                                        ? '90-Day Credit:APPROVED'
                                        : '90-Day Credit: LOCKED',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,

                                      color: credit90
                                          ? AppColors.dealerColor
                                          : AppColors.textMuted,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Key Difference Notice Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.visibility,
                        color: Colors.amber,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Dealer Privileges Active',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF7C5E10),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'You have full visibility of real-time warehouse inventory quantities and discounted dealer wholesale pricing.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF7C5E10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Quick Navigation Actions
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DealerCatalogView(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(
                                Icons.inventory,
                                color: AppColors.dealerColor,
                                size: 28,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Wholesale Catalog',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Browse prices & stock',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DealerCreditStatusView(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.secondary,
                                size: 28,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Credit Facility',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '30 & 90 Days terms',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
