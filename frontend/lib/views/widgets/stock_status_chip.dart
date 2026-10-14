import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StockStatusChip extends StatelessWidget {
  final bool inStock;
  final int? stockQuantity;
  const StockStatusChip({super.key, required this.inStock, this.stockQuantity});

  @override
  Widget build(BuildContext context) {
    if (stockQuantity != null) {
      final isLow = stockQuantity! < 20;
      final color = isLow ? AppColors.warning : AppColors.success;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              'Stock: $stockQuantity units',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      );
    }

    final color = inStock ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            inStock ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            inStock ? 'In Stock' : 'Out of Stock',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
