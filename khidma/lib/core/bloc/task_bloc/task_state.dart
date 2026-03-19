import 'package:equatable/equatable.dart';
import '../../../../models/order.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskCreatedSuccessfully extends TaskState {
  final Order order;

  const TaskCreatedSuccessfully(this.order);

  @override
  List<Object?> get props => [order];
}

class TasksLoaded extends TaskState {
  final List<Order> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
