import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/stock_status_chip.dart';
import 'dealer_checkout_view.dart';

class DealerCatalogView extends StatefulWidget {
  const DealerCatalogView({super.key});

  @override
  State<DealerCatalogView> createState() => _DealerCatalogViewState();
}

class _DealerCatalogViewState extends State<DealerCatalogView> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wholesale Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cart) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: AppColors.dealerColor),
                    onPressed: () {
                      if (cart.items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cart is empty. Add items first.')),
                        );
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DealerCheckoutView()),
                      );
                    },
                  ),
                  if (cart.totalItemCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.totalItemCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            return Column(
              children: [
                // Highlight Banner explaining stock transparency
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: AppColors.dealerColor.withOpacity(0.08),
                  child: Row(
                    children: const [
                      Icon(Icons.inventory_2, size: 16, color: AppColors.dealerColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Live Zoho Inventory Mode: Stock levels updated dynamically.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.dealerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      product.imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 80,
                                        height: 80,
                                        color: AppColors.border,
                                        child: const Icon(Icons.plumbing, color: AppColors.textMuted),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'SKU: ${product.sku} • Category: ${product.category}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                        ),
                                        const SizedBox(height: 8),

                                        // Crucial Stock Display for Dealers
                                        StockStatusChip(
                                          inStock: product.inStock,
                                          stockQuantity: product.stockQuantity ?? 180, // Explicit quantity visible to dealers!
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dealer Wholesale Price',
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${product.effectivePrice.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.dealerColor,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'MRP ₹${product.price.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              decoration: TextDecoration.lineThrough,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                                    label: const Text('Add to PO'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.dealerColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    ),
                                    onPressed: () {
                                      context.read<CartBloc>().add(AddToCartEvent(product, quantity: 10)); // Dealers order wholesale lots
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Added 10 units of ${product.name} to Purchase Order'),
                                          duration: const Duration(seconds: 1),
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
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
