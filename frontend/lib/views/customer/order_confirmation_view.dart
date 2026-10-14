import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/primary_button.dart';
import 'order_tracking_view.dart';
import 'customer_main_shell.dart';

class OrderConfirmationView extends StatelessWidget {
  final OrderModel order;

  const OrderConfirmationView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 72,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Thank you for your purchase. Your order has been placed and confirmed with the warehouse.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Order Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Order Number', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount Paid', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        Text('₹${order.netPayable.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment Type', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        Text(order.paymentMethod.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              PrimaryButton(
                text: 'Track Order',
                icon: Icons.local_shipping,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingDetailView(orderId: order.id),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const CustomerMainShell()),
                    (route) => false,
                  );
                },
                child: const Text('Continue Shopping'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
