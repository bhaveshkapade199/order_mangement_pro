import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class PlaceOrderEvent extends OrderEvent {
  final List<Map<String, dynamic>> items;
  final String paymentMethod;
  final Map<String, dynamic>? shippingAddress;

  const PlaceOrderEvent({
    required this.items,
    required this.paymentMethod,
    this.shippingAddress,
  });

  @override
  List<Object?> get props => [items, paymentMethod];
}

class LoadMyOrdersEvent extends OrderEvent {}

class LoadOrderTrackingEvent extends OrderEvent {
  final String orderId;

  const LoadOrderTrackingEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
