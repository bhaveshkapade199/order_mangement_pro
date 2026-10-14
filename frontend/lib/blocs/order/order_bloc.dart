import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrderInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<LoadMyOrdersEvent>(_onLoadMyOrders);
    on<LoadOrderTrackingEvent>(_onLoadOrderTracking);
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderPlacing());
    try {
      final order = await _orderRepository.createOrder(
        items: event.items,
        paymentMethod: event.paymentMethod,
        shippingAddress: event.shippingAddress,
      );
      emit(OrderSuccess(order));
    } catch (e) {
      emit(OrderFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadMyOrders(
    LoadMyOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await _orderRepository.getMyOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadOrderTracking(
    LoadOrderTrackingEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderTrackingLoading());
    try {
      final tracking = await _orderRepository.getOrderTracking(event.orderId);
      emit(OrderTrackingLoaded(tracking));
    } catch (e) {
      emit(OrderFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
