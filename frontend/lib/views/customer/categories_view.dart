import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';
import '../../core/constants/app_colors.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Categories', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded) {
            final validCats = state.categories.where((c) => c.name != 'All').toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: validCats.length,
              itemBuilder: (context, index) {
                final cat = validCats[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  elevation: 0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.plumbing, color: AppColors.primary),
                    ),
                    title: Text(
                      cat.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Text(
                      cat.description.isNotEmpty ? cat.description : 'Certified components',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                    onTap: () {
                      context.read<ProductBloc>().add(FilterCategoryEvent(cat.name));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Filtered catalog by ${cat.name}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
