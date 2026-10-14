import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PlumberProductsView extends StatelessWidget {
  const PlumberProductsView({super.key});

  final List<Map<String, dynamic>> _supplies = const [
    {
      'name': 'Heavy-Duty CPVC Solvent Cement 250ml',
      'sku': 'ACC-SOLV-CEMT-250',
      'price': 160.0,
      'unit': 'tin',
      'category': 'Adhesives',
      'desc': 'Fast setting solvent for all classes and schedules of CPVC pipe.',
      'imageUrl': 'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Quarter-Turn Brass Ball Valve 1/2"',
      'sku': 'VLV-BRS-BALL-050',
      'price': 280.0,
      'unit': 'pcs',
      'category': 'Valves',
      'desc': 'Solid forged brass ball valve with chrome plating and leakproof seal.',
      'imageUrl': 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'PTFE High Density Teflon Tape 12mm x 10m',
      'sku': 'ACC-TEF-12MM',
      'price': 25.0,
      'unit': 'roll',
      'category': 'Sealing',
      'desc': 'High density thread seal tape for leak-proof pipe joints.',
      'imageUrl': 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Stainless Steel Anti-Cockroach Floor Trap',
      'sku': 'DRN-SS-TRAP-100',
      'price': 380.0,
      'unit': 'pcs',
      'category': 'Drainage',
      'desc': 'Grade 304 SS floor drain with odor seal and removable hair strainer.',
      'imageUrl': 'https://images.unsplash.com/photo-1507652313519-d4e9174996dd?auto=format&fit=crop&w=600&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Plumbing Spare Parts & Supplies', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _supplies.length,
        itemBuilder: (context, index) {
          final item = _supplies[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.border),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['imageUrl'],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 70,
                        height: 70,
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
                          item['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'SKU: ${item['sku']} • ${item['category']}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${item['price']} / ${item['unit']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.plumberColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.plumberColor),
                    tooltip: 'Request Part for Current Job',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Requisition logged: ${item['name']}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
