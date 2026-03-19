import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../../../models/khidma_user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UpdateProfileEvent>((event, emit) {
      if (state is UserProfileLoaded) {
        emit((state as UserProfileLoaded).copyWith(user: event.user));
      }
    });

    on<ToggleThemeEvent>((event, emit) {
      if (state is UserProfileLoaded) {
        final current = state as UserProfileLoaded;
        emit(current.copyWith(isDarkMode: !current.isDarkMode));
      }
    });

    // Initial fetch mock
    on<FetchUserStatsEvent>((event, emit) async {
       emit(UserLoading());
       // simulate network
       await Future.delayed(const Duration(milliseconds: 500));
       emit(UserProfileLoaded(
         user: KhidmaUser(
           id: 'u1',
           name: 'User',
           role: 'client',
           city: 'Cairo',
           rating: 5.0,
           avatarUrl: '',
         ),
       ));
    });
  }
}
