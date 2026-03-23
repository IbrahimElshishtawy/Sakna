import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../../../models/order.dart';

import '../../api_service.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ApiService _apiService = ApiService();

  TaskBloc() : super(TaskInitial()) {
    on<CreateTaskEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        // Real Backend Integration
        final response = await _apiService.post('/tasks/create', event.request.toJson());
        final order = Order.fromMap(response);
        emit(TaskCreatedSuccessfully(order));
      } catch (e) {
        emit(const TaskError('Failed to create task'));
      }
    });

    on<FetchTasksEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));
        // Return mock data for now
        emit(const TasksLoaded([]));
      } catch (e) {
        emit(const TaskError('Failed to fetch tasks'));
      }
    });
  }
}
