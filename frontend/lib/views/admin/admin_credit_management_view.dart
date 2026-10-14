import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../blocs/admin/admin_bloc.dart';
import '../../blocs/admin/admin_event.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/primary_button.dart';

class AdminCreditManagementView extends StatefulWidget {
  final UserModel dealer;

  const AdminCreditManagementView({super.key, required this.dealer});

  @override
  State<AdminCreditManagementView> createState() => _AdminCreditManagementViewState();
}

class _AdminCreditManagementViewState extends State<AdminCreditManagementView> {
  late final TextEditingController _limitController;
  late bool _credit30;
  late bool _credit90;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _limitController = TextEditingController(text: widget.dealer.creditLimit.toStringAsFixed(0));
    _credit30 = widget.dealer.credit30Allowed;
    _credit90 = widget.dealer.credit90Allowed;
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final limit = double.tryParse(_limitController.text) ?? widget.dealer.creditLimit;
    setState(() => _isSaving = true);

    context.read<AdminBloc>().add(
          UpdateDealerCreditEligibilityEvent(
            userId: widget.dealer.id,
            creditLimit: limit,
            credit30Allowed: _credit30,
            credit90Allowed: _credit90,
          ),
        );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated credit permissions for ${widget.dealer.name}')),
        );
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Dealer Credit Terms', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dealer Info Card
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
                      Text(
                        widget.dealer.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.dealerColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.dealer.zohoContactId ?? 'ZC-DL-9081',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: AppColors.dealerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Mobile: +91-${widget.dealer.mobileNumber}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.verified, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        widget.dealer.zohoVerified ? 'Zoho CRM Verified' : 'Pending Zoho Verification',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.dealer.zohoVerified ? AppColors.success : AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Credit Limit Allocation (₹)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _limitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                hintText: 'Enter total credit limit',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Revolving Credit Term Permissions',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            // Toggle 30 Days Credit Permission
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: SwitchListTile(
                value: _credit30,
                activeColor: AppColors.success,
                title: const Text('30-Day Credit Permission', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Allow dealer to place purchase orders with 30-day payment terms.', style: TextStyle(fontSize: 12)),
                onChanged: (val) => setState(() => _credit30 = val),
              ),
            ),

            const SizedBox(height: 12),

            // Toggle 90 Days Credit Permission (Key requirement: "30/90-day credit permissions")
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: SwitchListTile(
                value: _credit90,
                activeColor: AppColors.dealerColor,
                title: Row(
                  children: const [
                    Text('90-Day Credit Permission', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(width: 8),
                    Text('(Tier-1 Only)', style: TextStyle(color: AppColors.dealerColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                subtitle: const Text(
                  'Exclusive extended credit period reserved for high-turnover verified dealers.',
                  style: TextStyle(fontSize: 12),
                ),
                onChanged: (val) => setState(() => _credit90 = val),
              ),
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Save Credit Permissions',
              isLoading: _isSaving,
              backgroundColor: AppColors.adminColor,
              onPressed: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}
