import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/primary_button.dart';
import '../customer/customer_main_shell.dart';
import '../dealer/dealer_main_shell.dart';
import '../plumber/plumber_main_shell.dart';
import '../admin/admin_main_shell.dart';

class OtpVerificationView extends StatefulWidget {
  final String mobileNumber;
  final String role;
  final String? debugOtp;

  const OtpVerificationView({
    super.key,
    required this.mobileNumber,
    required this.role,
    this.debugOtp,
  });

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController(text: widget.debugOtp ?? '123456');
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit OTP')),
      );
      return;
    }

    context.read<AuthBloc>().add(
          AuthVerifyOtpRequested(
            mobileNumber: widget.mobileNumber,
            otp: code,
            role: widget.role,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Widget targetScreen;
            switch (state.user.role.toLowerCase()) {
              case AppConstants.roleDealer:
                targetScreen = const DealerMainShell();
                break;
              case AppConstants.rolePlumber:
                targetScreen = const PlumberMainShell();
                break;
              case AppConstants.roleAdmin:
                targetScreen = const AdminMainShell();
                break;
              case AppConstants.roleCustomer:
              default:
                targetScreen = const CustomerMainShell();
                break;
            }

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => targetScreen),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
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
                  const Text(
                    'Verify OTP Code',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We sent a 6-digit OTP to +91-${widget.mobileNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Demo OTP Helper Pill
                  if (widget.debugOtp != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.key, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Test OTP: ${widget.debugOtp} (auto-filled)',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // OTP TextField
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 16,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '------',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),

                  const Spacer(),

                  PrimaryButton(
                    text: 'Verify & Continue',
                    isLoading: isLoading,
                    onPressed: _handleVerify,
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
