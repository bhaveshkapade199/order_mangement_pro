import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/admin_repository.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;

  AdminBloc({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(AdminInitial()) {
    on<LoadAdminDataEvent>(_onLoadAdminData);
    on<UpdateDealerCreditEligibilityEvent>(_onUpdateDealerCredit);
    on<TriggerZohoSyncEvent>(_onTriggerZohoSync);
  }

  Future<void> _onLoadAdminData(
    LoadAdminDataEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      final users = await _adminRepository.getUsers();
      final orders = await _adminRepository.getAllOrders();
      final reports = await _adminRepository.getReports();

      emit(AdminLoaded(users: users, orders: orders, reports: reports));
    } catch (e) {
      emit(AdminFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdateDealerCredit(
    UpdateDealerCreditEligibilityEvent event,
    Emitter<AdminState> emit,
  ) async {
    try {
      await _adminRepository.updateDealerCredit(
        userId: event.userId,
        creditLimit: event.creditLimit,
        credit30Allowed: event.credit30Allowed,
        credit90Allowed: event.credit90Allowed,
      );
      add(LoadAdminDataEvent());
    } catch (e) {
      emit(AdminFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onTriggerZohoSync(
    TriggerZohoSyncEvent event,
    Emitter<AdminState> emit,
  ) async {
    if (state is AdminLoaded) {
      final current = state as AdminLoaded;
      try {
        final res = await _adminRepository.triggerZohoSync();
        emit(
          AdminLoaded(
            users: current.users,
            orders: current.orders,
            reports: current.reports,
            syncSuccessMessage: 'Zoho Sync Succeeded: ${res['createdCount']} created, ${res['updatedCount']} updated!',
          ),
        );
      } catch (e) {
        emit(AdminFailure(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }
}
