import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc<T> extends Bloc<PaginationEvent, PaginationState<T>> {
  final Future<List<T>> Function(int page) fetchPage;

  PaginationBloc({required this.fetchPage}) : super(const PaginationInitial<T>()) {
    on<FetchPageEvent>(_onFetchPage);
    on<RefreshListEvent>(_onRefreshList);
  }

  Future<void> _onFetchPage(FetchPageEvent event, Emitter<PaginationState<T>> emit) async {
    if (state is PaginationLoading<T> || (state is PaginationSuccess<T> && (state as PaginationSuccess<T>).hasReachedMax)) return;

    try {
      if (state is PaginationInitial<T> || state is PaginationError<T>) {
        emit(PaginationLoading<T>());
        final items = await fetchPage(1);
        emit(PaginationSuccess<T>(items: items, hasReachedMax: items.isEmpty, currentPage: 1));
      } else if (state is PaginationSuccess<T>) {
        final currentState = state as PaginationSuccess<T>;
        emit(PaginationLoading<T>(items: currentState.items, currentPage: currentState.currentPage));
        final nextPage = currentState.currentPage + 1;
        final items = await fetchPage(nextPage);
        items.isEmpty
            ? emit(currentState.copyWith(hasReachedMax: true))
            : emit(PaginationSuccess<T>(
                items: List.of(currentState.items)..addAll(items),
                hasReachedMax: false,
                currentPage: nextPage,
              ));
      }
    } catch (e) {
      if(state is PaginationSuccess<T>) {
         emit(PaginationError<T>(message: e.toString(), items: (state as PaginationSuccess<T>).items, currentPage: (state as PaginationSuccess<T>).currentPage));
      } else {
         emit(PaginationError<T>(message: e.toString()));
      }
    }
  }

  Future<void> _onRefreshList(RefreshListEvent event, Emitter<PaginationState<T>> emit) async {
    emit(const PaginationInitial<T>());
    add(FetchPageEvent());
  }
}
