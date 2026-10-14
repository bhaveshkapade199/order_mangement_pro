import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final String selectedCategory;

  const ProductLoaded({
    required this.products,
    required this.categories,
    this.selectedCategory = 'All',
  });

  @override
  List<Object?> get props => [products, categories, selectedCategory];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
