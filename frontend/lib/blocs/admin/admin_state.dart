import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart';

export 'admin_event.dart';

// States
abstract class AdminState extends Equatable {
  const AdminState();
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<UserModel> users;
  final List<OrderModel> orders;
  final Map<String, dynamic> reports;
  final String? syncSuccessMessage;

  const AdminLoaded({
    required this.users,
    required this.orders,
    required this.reports,
    this.syncSuccessMessage,
  });

  @override
  List<Object?> get props => [users, orders, reports, syncSuccessMessage];
}

class AdminFailure extends AdminState {
  final String message;

  const AdminFailure(this.message);

  @override
  List<Object?> get props => [message];
}
