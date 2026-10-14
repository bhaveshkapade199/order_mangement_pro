import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/plumber_repository.dart';
import 'plumber_state.dart';

class PlumberBloc extends Bloc<PlumberEvent, PlumberState> {
  final PlumberRepository _plumberRepository;

  PlumberBloc({required PlumberRepository plumberRepository})
      : _plumberRepository = plumberRepository,
        super(PlumberInitial()) {
    on<LoadPlumberDashboardEvent>(_onLoadDashboard);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
  }

  Future<void> _onLoadDashboard(
    LoadPlumberDashboardEvent event,
    Emitter<PlumberState> emit,
  ) async {
    emit(PlumberLoading());
    try {
      final summary = await _plumberRepository.getDashboard();
      final tasks = await _plumberRepository.getTasks();
      final products = await _plumberRepository.getPlumberProducts();
      final notifs = await _plumberRepository.getNotifications();

      emit(
        PlumberLoaded(
          summary: summary,
          tasks: tasks,
          products: products,
          notifications: notifs,
        ),
      );
    } catch (e) {
      emit(PlumberFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatusEvent event,
    Emitter<PlumberState> emit,
  ) async {
    try {
      await _plumberRepository.updateTaskStatus(
        taskId: event.taskId,
        status: event.status,
        completionNotes: event.completionNotes,
      );
      add(LoadPlumberDashboardEvent());
    } catch (e) {
      emit(PlumberFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
