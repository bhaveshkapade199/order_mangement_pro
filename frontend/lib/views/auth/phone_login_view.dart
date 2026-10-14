import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/primary_button.dart';
import '../widgets/role_badge.dart';
import '../widgets/server_config_dialog.dart';
import 'otp_verification_view.dart';

class PhoneLoginView extends StatefulWidget {
  final String selectedRole;
  final String suggestedNumber;

  const PhoneLoginView({
    super.key,
    required this.selectedRole,
    required this.suggestedNumber,
  });

  @override
  State<PhoneLoginView> createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.suggestedNumber);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    final mobile = _phoneController.text.trim();
    if (mobile.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    context.read<AuthBloc>().add(
          AuthSendOtpRequested(
            mobileNumber: mobile,
            role: widget.selectedRole,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDealer = widget.selectedRole == AppConstants.roleDealer;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dns_outlined, color: AppColors.textSecondary),
            tooltip: 'Server Settings',
            onPressed: () => ServerConfigDialog.show(context),
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSent) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OtpVerificationView(
                  mobileNumber: state.mobileNumber,
                  role: state.role,
                  debugOtp: state.debugOtp,
                ),
              ),
            );
          } else if (state is AuthFailure) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Row(
                  children: const [
                    Icon(Icons.error_outline, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Authentication Notice'),
                  ],
                ),
                content: Text(
                  state.message,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                actions: [
                  TextButton.icon(
                    icon: const Icon(Icons.settings_ethernet, size: 16),
                    label: const Text('Change Server IP'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ServerConfigDialog.show(context);
                    },
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoleBadge(role: widget.selectedRole),
                  const SizedBox(height: 16),
                  const Text(
                    'Login with OTP',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isDealer
                        ? 'Dealers must be registered & verified in Zoho CRM to access the wholesale dashboard.'
                        : 'Enter your 10-digit mobile number to receive a secure one-time password.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Mobile Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: AppColors.border),
                            ),
                          ),
                          child: const Text(
                            '+91',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              hintText: 'Enter Mobile Number',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isDealer) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.dealerColor.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.dealerColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_user, size: 18, color: AppColors.dealerColor),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Zoho Integration Rule: Only pre-verified Zoho contacts can log in.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.dealerColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  PrimaryButton(
                    text: 'Send Verification OTP',
                    isLoading: isLoading,
                    onPressed: _handleSendOtp,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
