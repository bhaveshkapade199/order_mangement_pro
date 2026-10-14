import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  double get subtotal => product.effectivePrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product.id, quantity];
}

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final ProductModel product;
  final int quantity;

  const AddToCartEvent(this.product, {this.quantity = 1});

  @override
  List<Object?> get props => [product, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;

  const RemoveFromCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantityEvent(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class ClearCartEvent extends CartEvent {}
