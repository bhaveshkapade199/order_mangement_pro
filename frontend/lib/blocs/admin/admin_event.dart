import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();
  @override
  List<Object?> get props => [];
}

class LoadAdminDataEvent extends AdminEvent {}

class UpdateDealerCreditEligibilityEvent extends AdminEvent {
  final String userId;
  final double creditLimit;
  final bool credit30Allowed;
  final bool credit90Allowed;

  const UpdateDealerCreditEligibilityEvent({
    required this.userId,
    required this.creditLimit,
    required this.credit30Allowed,
    required this.credit90Allowed,
  });

  @override
  List<Object?> get props => [userId, creditLimit, credit30Allowed, credit90Allowed];
}

class TriggerZohoSyncEvent extends AdminEvent {}
