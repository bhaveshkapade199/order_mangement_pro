import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

import 'phone_login_view.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to FlowPro',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select your user role to experience the role-specific flow, pricing, stock visibility, and credit approvals.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Role Card 1: Customer
              _buildRoleCard(
                context,
                role: AppConstants.roleCustomer,
                title: 'Retail Customer',
                subtitle:
                    'Browse catalog, direct checkout via online payment, order tracking. (Stock quantity hidden)',
                icon: Icons.person_outline,
                color: AppColors.customerColor,
                demoNumber: '9999900001',
                verificationNote: 'Self-registration with mobile OTP',
              ),

              const SizedBox(height: 16),

              // Role Card 2: Dealer
              _buildRoleCard(
                context,
                role: AppConstants.roleDealer,
                title: 'Commercial Dealer',
                subtitle:
                    'Zoho CRM verified login, wholesale pricing, exact warehouse stock visibility, 30 & 90 days credit terms.',
                icon: Icons.storefront_outlined,
                color: AppColors.dealerColor,
                demoNumber: '9876543210',
                verificationNote: 'Mandatory Zoho CRM verification required',
              ),

              const SizedBox(height: 16),

              // Role Card 3: Plumber
              _buildRoleCard(
                context,
                role: AppConstants.rolePlumber,
                title: 'Certified Plumber',
                subtitle:
                    'Plumber dashboard, assigned field activities, status updates, fast-moving plumbing supplies catalog.',
                icon: Icons.handyman_outlined,
                color: AppColors.plumberColor,
                demoNumber: '9888800001',
                verificationNote: 'Requires verified plumber certification',
              ),

              const SizedBox(height: 16),

              // Role Card 4: Admin
              _buildRoleCard(
                context,
                role: AppConstants.roleAdmin,
                title: 'System Administrator',
                subtitle:
                    'Manage credit limits, approve 30/90 days dealer credit, trigger Zoho Workbook sync & executive reports.',
                icon: Icons.admin_panel_settings_outlined,
                color: AppColors.adminColor,
                demoNumber: '9000000001',
                verificationNote: 'Full administrative governance access',
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String demoNumber,
    required String verificationNote,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                PhoneLoginView(selectedRole: role, suggestedNumber: demoNumber),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.25), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),

              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    verificationNote,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: color.withOpacity(0.85),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Demo Mobile: $demoNumber (OTP: 123456)',
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
