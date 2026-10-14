import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/admin/admin_bloc.dart';
import '../../blocs/admin/admin_state.dart';
import '../../core/constants/app_colors.dart';
import '../customer/order_tracking_view.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Commercial Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = state is AdminLoaded ? state.orders : [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.receipt_long, size: 60, color: AppColors.textMuted),
                  SizedBox(height: 12),
                  Text('No orders in the system yet', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminBloc>().add(LoadAdminDataEvent());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final isCredit = order.paymentMethod.startsWith('credit');

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
                            Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (isCredit ? AppColors.dealerColor : AppColors.primary).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                order.paymentMethod.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isCredit ? AppColors.dealerColor : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${order.items.length} items • Total: ₹${order.netPayable.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        if (isCredit && order.creditDueDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Due: ${order.creditDueDate!.day}/${order.creditDueDate!.month}/${order.creditDueDate!.year} (${order.creditDays} Days Term)',
                            style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w600),
                          ),
                        ],
                        const Divider(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status: ${order.orderStatus.toUpperCase()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            TextButton.icon(
                              icon: const Icon(Icons.timeline, size: 16),
                              label: const Text('View Tracking'),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OrderTrackingDetailView(orderId: order.id),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
