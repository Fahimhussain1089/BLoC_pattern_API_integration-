import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class UserListState extends Equatable {
  const UserListState();

  @override
  List<Object> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<Users> users;
  final bool hasReachedMax;
  final bool isSearching;
  final String searchQuery;

  const UserListLoaded({
    required this.users,
    this.hasReachedMax = false,
    this.isSearching = false,
    this.searchQuery = '',
  });

  UserListLoaded copyWith({
    List<Users>? users,
    bool? hasReachedMax,
    bool? isSearching,
    String? searchQuery,
  }) {
    return UserListLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [users, hasReachedMax, isSearching, searchQuery];
}

class UserListError extends UserListState {
  final String message;

  const UserListError(this.message);

  @override
  List<Object> get props => [message];
}