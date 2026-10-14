import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.items);
    final index = currentItems.indexWhere((item) => item.product.id == event.product.id);

    if (index >= 0) {
      final existing = currentItems[index];
      currentItems[index] = existing.copyWith(quantity: existing.quantity + event.quantity);
    } else {
      currentItems.add(CartItem(product: event.product, quantity: event.quantity));
    }

    emit(state.copyWith(items: currentItems));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final currentItems = state.items.where((item) => item.product.id != event.productId).toList();
    emit(state.copyWith(items: currentItems));
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    if (event.quantity <= 0) {
      add(RemoveFromCartEvent(event.productId));
      return;
    }

    final currentItems = state.items.map((item) {
      if (item.product.id == event.productId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: currentItems));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }
}
