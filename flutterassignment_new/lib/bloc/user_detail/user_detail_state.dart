import 'package:equatable/equatable.dart';
import '../../models/post_model.dart';
import '../../models/todo_model.dart';

abstract class UserDetailState extends Equatable {
  const UserDetailState();

  @override
  List<Object> get props => [];
}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  final List<Post> posts;
  final List<Todo> todos;
  final List<Post> localPosts;

  const UserDetailLoaded({
    required this.posts,
    required this.todos,
    this.localPosts = const [],
  });

  UserDetailLoaded copyWith({
    List<Post>? posts,
    List<Todo>? todos,
    List<Post>? localPosts,
  }) {
    return UserDetailLoaded(
      posts: posts ?? this.posts,
      todos: todos ?? this.todos,
      localPosts: localPosts ?? this.localPosts,
    );
  }

  List<Post> get allPosts => [...localPosts, ...posts];

  @override
  List<Object> get props => [posts, todos, localPosts];
}

class UserDetailError extends UserDetailState {
  final String message;

  const UserDetailError(this.message);

  @override
  List<Object> get props => [message];
}