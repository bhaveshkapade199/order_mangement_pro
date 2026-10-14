import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  final String? category;
  final String? search;

  const LoadProductsEvent({this.category, this.search});

  @override
  List<Object?> get props => [category, search];
}

class FilterCategoryEvent extends ProductEvent {
  final String category;

  const FilterCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}
