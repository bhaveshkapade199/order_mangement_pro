import 'package:equatable/equatable.dart';
import '../../models/order_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderSuccess extends OrderState {
  final OrderModel order;

  const OrderSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class OrdersLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderTrackingLoading extends OrderState {}

class OrderTrackingLoaded extends OrderState {
  final Map<String, dynamic> trackingData;

  const OrderTrackingLoaded(this.trackingData);

  @override
  List<Object?> get props => [trackingData];
}

class OrderFailure extends OrderState {
  final String message;

  const OrderFailure(this.message);

  @override
  List<Object?> get props => [message];
}
