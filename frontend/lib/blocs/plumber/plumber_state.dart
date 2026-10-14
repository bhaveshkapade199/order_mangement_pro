import 'package:equatable/equatable.dart';
import '../../models/plumber_task_model.dart';
import '../../models/product_model.dart';

// Events
abstract class PlumberEvent extends Equatable {
  const PlumberEvent();
  @override
  List<Object?> get props => [];
}

class LoadPlumberDashboardEvent extends PlumberEvent {}

class UpdateTaskStatusEvent extends PlumberEvent {
  final String taskId;
  final String status;
  final String? completionNotes;

  const UpdateTaskStatusEvent({
    required this.taskId,
    required this.status,
    this.completionNotes,
  });

  @override
  List<Object?> get props => [taskId, status, completionNotes];
}

// States
abstract class PlumberState extends Equatable {
  const PlumberState();
  @override
  List<Object?> get props => [];
}

class PlumberInitial extends PlumberState {}

class PlumberLoading extends PlumberState {}

class PlumberLoaded extends PlumberState {
  final Map<String, dynamic> summary;
  final List<PlumberTaskModel> tasks;
  final List<ProductModel> products;
  final List<Map<String, dynamic>> notifications;

  const PlumberLoaded({
    required this.summary,
    required this.tasks,
    required this.products,
    required this.notifications,
  });

  @override
  List<Object?> get props => [summary, tasks, products, notifications];
}

class PlumberFailure extends PlumberState {
  final String message;

  const PlumberFailure(this.message);

  @override
  List<Object?> get props => [message];
}
