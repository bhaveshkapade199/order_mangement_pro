import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/product_repository.dart';
import '../../models/category_model.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<FilterCategoryEvent>(_onFilterCategory);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final categories = await _productRepository.getCategories();
      final products = await _productRepository.getProducts(
        category: event.category,
        search: event.search,
      );

      final allCategories = [
        const CategoryModel(id: 'all', name: 'All', slug: 'all', iconName: 'apps', description: 'All products'),
        ...categories,
      ];

      emit(
        ProductLoaded(
          products: products,
          categories: allCategories,
          selectedCategory: event.category ?? 'All',
        ),
      );
    } catch (e) {
      emit(ProductError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onFilterCategory(
    FilterCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      emit(ProductLoading());
      try {
        final products = await _productRepository.getProducts(
          category: event.category == 'All' ? null : event.category,
        );
        emit(
          ProductLoaded(
            products: products,
            categories: current.categories,
            selectedCategory: event.category,
          ),
        );
      } catch (e) {
        emit(ProductError(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }
}
