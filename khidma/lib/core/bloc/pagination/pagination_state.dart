part of 'pagination_bloc.dart';

abstract class PaginationState<T> extends Equatable {
  final List<T> items;
  final int currentPage;

  const PaginationState({this.items = const [], this.currentPage = 1});

  @override
  List<Object?> get props => [items, currentPage];
}

class PaginationInitial<T> extends PaginationState<T> {
  const PaginationInitial() : super();
}

class PaginationLoading<T> extends PaginationState<T> {
  const PaginationLoading({super.items, super.currentPage});
}

class PaginationSuccess<T> extends PaginationState<T> {
  final bool hasReachedMax;

  const PaginationSuccess({required super.items, required this.hasReachedMax, required super.currentPage});

  PaginationSuccess<T> copyWith({
    List<T>? items,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return PaginationSuccess<T>(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [items, hasReachedMax, currentPage];
}

class PaginationError<T> extends PaginationState<T> {
  final String message;

  const PaginationError({required this.message, super.items, super.currentPage});

  @override
  List<Object?> get props => [message, items, currentPage];
}
