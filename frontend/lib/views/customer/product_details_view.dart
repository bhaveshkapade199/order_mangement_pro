import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product_model.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/stock_status_chip.dart';
import 'cart_view.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartView()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Banner Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      p.imageUrl,
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 240,
                        color: AppColors.border,
                        child: const Icon(Icons.plumbing, size: 64, color: AppColors.textMuted),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        p.category,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      StockStatusChip(
                        inStock: p.inStock,
                        stockQuantity: p.stockQuantity,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'SKU: ${p.sku} • Zoho ID: ${p.zohoItemId}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: AppColors.textMuted,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Pricing Section
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price (per unit)',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹${p.effectivePrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        // Quantity Stepper
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                              ),
                              Text(
                                '$_quantity',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                onPressed: () => setState(() => _quantity++),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Description & Specification',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.description.isNotEmpty
                        ? p.description
                        : 'Certified industrial grade material. Conforms to ISO and ASTM national standards.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.verified, size: 18, color: AppColors.info),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Fetched dynamically from Zoho Workbook Inventory Master.',
                            style: TextStyle(fontSize: 12, color: AppColors.info, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Checkout Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Add to Cart • ₹${(p.effectivePrice * _quantity).toStringAsFixed(0)}',
                    icon: Icons.add_shopping_cart,
                    onPressed: () {
                      context.read<CartBloc>().add(AddToCartEvent(p, quantity: _quantity));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added $_quantity ${p.name} to cart'),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const CartView()),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
