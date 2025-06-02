import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_repository.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';
import '../../models/user_model.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final UserRepository userRepository;
  List<Users> _allUsers = [];
  int _currentSkip = 0;
  final int _limit = 10;
  String _currentSearchQuery = '';

  UserListBloc({required this.userRepository}) : super(UserListInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<SearchUsers>(_onSearchUsers);
    on<RefreshUsers>(_onRefreshUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserListState> emit) async {
    emit(UserListLoading());
    try {
      final userData = await userRepository.getUsers(limit: _limit, skip: 0);
      _allUsers = userData.users ?? [];
      _currentSkip = _limit;

      emit(UserListLoaded(
        users: _allUsers,
        hasReachedMax: _allUsers.length < _limit,
      ));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }

  Future<void> _onLoadMoreUsers(LoadMoreUsers event, Emitter<UserListState> emit) async {
    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;
      if (currentState.hasReachedMax) return;

      try {
        final userData = _currentSearchQuery.isEmpty
            ? await userRepository.getUsers(limit: _limit, skip: _currentSkip)
            : await userRepository.searchUsers(_currentSearchQuery, limit: _limit, skip: _currentSkip);

        final newUsers = userData.users ?? [];
        _allUsers.addAll(newUsers);
        _currentSkip += _limit;

        emit(currentState.copyWith(
          users: _allUsers,
          hasReachedMax: newUsers.length < _limit,
        ));
      } catch (e) {
        emit(UserListError(e.toString()));
      }
    }
  }

  Future<void> _onSearchUsers(SearchUsers event, Emitter<UserListState> emit) async {
    _currentSearchQuery = event.query;
    _currentSkip = 0;
    _allUsers.clear();

    if (event.query.isEmpty) {
      add(LoadUsers());
      return;
    }

    emit(UserListLoading());
    try {
      final userData = await userRepository.searchUsers(event.query, limit: _limit, skip: 0);
      _allUsers = userData.users ?? [];
      _currentSkip = _limit;

      emit(UserListLoaded(
        users: _allUsers,
        hasReachedMax: _allUsers.length < _limit,
        isSearching: true,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }

  Future<void> _onRefreshUsers(RefreshUsers event, Emitter<UserListState> emit) async {
    _currentSkip = 0;
    _allUsers.clear();
    add(LoadUsers());
  }
}