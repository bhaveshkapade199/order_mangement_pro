import 'package:equatable/equatable.dart';
import 'cart_event.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get taxAmount => (subtotal * 0.18).roundToDouble();
  double get totalAmount => subtotal + taxAmount;
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items, totalAmount];
}
