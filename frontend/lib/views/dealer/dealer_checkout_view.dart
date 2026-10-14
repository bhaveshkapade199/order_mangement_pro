import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/primary_button.dart';
import '../customer/order_confirmation_view.dart';

class DealerCheckoutView extends StatefulWidget {
  const DealerCheckoutView({super.key});

  @override
  State<DealerCheckoutView> createState() => _DealerCheckoutViewState();
}

class _DealerCheckoutViewState extends State<DealerCheckoutView> {
  String _selectedPaymentMethod = AppConstants.paymentCredit30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Commercial Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            context.read<CartBloc>().add(ClearCartEvent());
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => OrderConfirmationView(order: state.order)),
              (route) => route.isFirst,
            );
          } else if (state is OrderFailure) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Credit Verification Notice'),
                content: Text(state.message),
                actions: [
                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state is OrderPlacing;

          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final user = authState is AuthAuthenticated ? authState.user : null;
              final credit30Allowed = user?.credit30Allowed ?? true;
              final credit90Allowed = user?.credit90Allowed ?? false; // 90 days condition
              final availableCredit = user != null ? (user.creditLimit - user.creditUsed) : 205000.0;

              return BlocBuilder<CartBloc, CartState>(
                builder: (context, cart) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Credit Line Availability Banner
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.dealerColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Approved Credit Facility', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  Text(
                                    '₹${availableCredit.toStringAsFixed(0)} available',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dealerColor),
                                  ),
                                ],
                              ),
                              const Icon(Icons.account_balance, color: AppColors.dealerColor),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'Select Dealer Payment Term',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 10),

                        // Payment Option 1: Upfront Payment
                        _buildPaymentOption(
                          value: AppConstants.paymentUpfront,
                          title: 'Upfront Payment (Direct RTGS / NEFT / Gateway)',
                          subtitle: 'Immediate settlement with 2% cash discount eligibility.',
                          isEligible: true,
                        ),

                        const SizedBox(height: 10),

                        // Payment Option 2: Credit Payment – 30 Days
                        _buildPaymentOption(
                          value: AppConstants.paymentCredit30,
                          title: 'Credit Payment – 30 Days Terms',
                          subtitle: 'Invoice payable within 30 days from billing date.',
                          isEligible: credit30Allowed,
                          tag: 'Standard Approved Credit',
                        ),

                        const SizedBox(height: 10),

                        // Payment Option 3: Credit Payment – 90 Days (Only for selected/approved dealers!)
                        _buildPaymentOption(
                          value: AppConstants.paymentCredit90,
                          title: 'Credit Payment – 90 Days Terms',
                          subtitle: credit90Allowed
                              ? 'Extended 90-day revolving credit period active for your tier.'
                              : 'Restricted: 90-day credit is available only for Tier-1 approved dealers.',
                          isEligible: credit90Allowed,
                          tag: credit90Allowed ? 'Tier-1 Approved' : 'Requires Admin Approval',
                        ),

                        const SizedBox(height: 20),

                        // Commercial PO Items Summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Purchase Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Wholesale Subtotal (${cart.totalItemCount} pcs)', style: const TextStyle(color: AppColors.textSecondary)),
                                  Text('₹${cart.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Commercial GST (18%)', style: TextStyle(color: AppColors.textSecondary)),
                                  Text('Applicable at billing', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Invoice Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text(
                                    '₹${cart.totalAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.dealerColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        PrimaryButton(
                          text: 'Confirm PO • ${_selectedPaymentMethod.toUpperCase()}',
                          backgroundColor: AppColors.dealerColor,
                          isLoading: isSubmitting,
                          onPressed: () {
                            final itemsPayload = cart.items.map((i) {
                              return {
                                'productId': i.product.id,
                                'quantity': i.quantity,
                                'name': i.product.name,
                              };
                            }).toList();

                            context.read<OrderBloc>().add(
                                  PlaceOrderEvent(
                                    items: itemsPayload,
                                    paymentMethod: _selectedPaymentMethod,
                                  ),
                                );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    required bool isEligible,
    String? tag,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return Container(
      decoration: BoxDecoration(
        color: isEligible ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.dealerColor : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: isEligible
            ? (val) {
                setState(() => _selectedPaymentMethod = val!);
              }
            : null,
        activeColor: AppColors.dealerColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isEligible ? AppColors.textPrimary : AppColors.textMuted,
                ),
              ),
            ),
            if (tag != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isEligible ? AppColors.dealerColor.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isEligible ? AppColors.dealerColor : AppColors.textMuted,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isEligible ? AppColors.textSecondary : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
