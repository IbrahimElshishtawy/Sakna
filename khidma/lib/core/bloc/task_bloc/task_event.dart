import 'package:equatable/equatable.dart';
import '../../../../models/task_request.dart';
import '../../../../models/order.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class CreateTaskEvent extends TaskEvent {
  final TaskRequest request;

  const CreateTaskEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateTaskStatusEvent extends TaskEvent {
  final String taskId;
  final String newStatus;

  const UpdateTaskStatusEvent(this.taskId, this.newStatus);

  @override
  List<Object?> get props => [taskId, newStatus];
}

class FetchTasksEvent extends TaskEvent {}
