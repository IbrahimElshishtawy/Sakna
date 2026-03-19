import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../../../models/order.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<CreateTaskEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));
        final order = Order(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: event.request.serviceType,
          location: event.request.location,
          dateTime: event.request.scheduledAt ?? DateTime.now(),
          price: event.request.hourlyPrice * event.request.hours * (event.request.isUrgent ? 1.5 : 1.0),
          status: 'pending',
          isUrgent: event.request.isUrgent,
        );
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
