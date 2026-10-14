import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/primary_button.dart';
import 'order_confirmation_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController _streetController = TextEditingController(text: 'Flat 302, Palm Heights, Main Link Rd');
  final TextEditingController _cityController = TextEditingController(text: 'Mumbai');
  final TextEditingController _zipController = TextEditingController(text: '400053');

  String _paymentOption = 'UPI / Instant Payment';

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder(CartState cart) {
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
            paymentMethod: AppConstants.paymentUpfront,
            shippingAddress: {
              'street': _streetController.text,
              'city': _cityController.text,
              'state': 'Maharashtra',
              'zip': _zipController.text,
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            context.read<CartBloc>().add(ClearCartEvent());
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => OrderConfirmationView(order: state.order),
              ),
              (route) => route.isFirst,
            );
          } else if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          final isPlacing = state is OrderPlacing;

          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cart) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping Address Card
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
                            children: const [
                              Icon(Icons.location_on, color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _streetController,
                            decoration: const InputDecoration(
                              labelText: 'Street Address',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _cityController,
                                  decoration: const InputDecoration(
                                    labelText: 'City',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _zipController,
                                  decoration: const InputDecoration(
                                    labelText: 'PIN Code',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Direct Payment Card (Customer Upfront Flow)
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
                            children: const [
                              Icon(Icons.payment, color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text('Direct Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Customers complete direct upfront payment via digital channels.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          RadioListTile<String>(
                            value: 'UPI / Instant Payment',
                            groupValue: _paymentOption,
                            onChanged: (val) => setState(() => _paymentOption = val!),
                            title: const Text('UPI / Google Pay / PhonePe', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: const Text('Zero convenience fees', style: TextStyle(fontSize: 12)),
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<String>(
                            value: 'Credit / Debit Card',
                            groupValue: _paymentOption,
                            onChanged: (val) => setState(() => _paymentOption = val!),
                            title: const Text('Credit or Debit Card', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            subtitle: const Text('Visa, MasterCard, Rupay', style: TextStyle(fontSize: 12)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Order Summary
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
                          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Items Total (${cart.totalItemCount})', style: const TextStyle(color: AppColors.textSecondary)),
                              Text('₹${cart.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Estimated GST', style: TextStyle(color: AppColors.textSecondary)),
                              Text('₹${cart.taxAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Grand Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(
                                '₹${cart.totalAmount.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    PrimaryButton(
                      text: 'Pay ₹${cart.totalAmount.toStringAsFixed(0)} & Place Order',
                      isLoading: isPlacing,
                      onPressed: () => _handlePlaceOrder(cart),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
