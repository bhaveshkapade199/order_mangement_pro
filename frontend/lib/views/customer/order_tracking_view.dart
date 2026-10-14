import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../core/constants/app_colors.dart';

class CustomerOrdersView extends StatefulWidget {
  const CustomerOrdersView({super.key});

  @override
  State<CustomerOrdersView> createState() => _CustomerOrdersViewState();
}

class _CustomerOrdersViewState extends State<CustomerOrdersView> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadMyOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders & Tracking', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textMuted),
                    SizedBox(height: 12),
                    Text('No orders placed yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<OrderBloc>().add(LoadMyOrdersEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.orderNumber,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  order.orderStatus.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Text(
                            '${order.items.length} items • ₹${order.netPayable.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Payment: ${order.paymentMethod.toUpperCase()} (${order.paymentStatus})',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.timeline, size: 16),
                              label: const Text('Track Shipment'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OrderTrackingDetailView(orderId: order.id),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class OrderTrackingDetailView extends StatefulWidget {
  final String orderId;

  const OrderTrackingDetailView({super.key, required this.orderId});

  @override
  State<OrderTrackingDetailView> createState() => _OrderTrackingDetailViewState();
}

class _OrderTrackingDetailViewState extends State<OrderTrackingDetailView> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrderTrackingEvent(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Order Tracking', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderTrackingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderTrackingLoaded) {
            final data = state.trackingData;
            final stages = data['stages'] as List<dynamic>? ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Overview Card
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ${data['orderNumber']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                data['orderStatus']?.toString().toUpperCase() ?? 'CONFIRMED',
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Payable: ₹${data['netPayable']}',
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Shipment Timeline',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),

                  // Vertical Stages Timeline
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stages.length,
                      itemBuilder: (context, index) {
                        final stage = stages[index];
                        final isCompleted = stage['completed'] == true;
                        final isLast = index == stages.length - 1;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCompleted ? AppColors.primary : AppColors.border,
                                  ),
                                  child: Icon(
                                    isCompleted ? Icons.check : Icons.circle,
                                    size: 14,
                                    color: isCompleted ? Colors.white : AppColors.textMuted,
                                  ),
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 44,
                                    color: isCompleted ? AppColors.primary : AppColors.border,
                                  ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stage['label'] ?? stage['key'],
                                      style: TextStyle(
                                        fontWeight: isCompleted ? FontWeight.bold : FontWeight.w500,
                                        fontSize: 14,
                                        color: isCompleted ? AppColors.textPrimary : AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isCompleted ? 'Completed' : 'Pending',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isCompleted ? AppColors.success : AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
