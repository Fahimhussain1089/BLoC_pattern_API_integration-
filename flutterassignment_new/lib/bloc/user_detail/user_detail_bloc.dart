import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_repository.dart';
import '../../models/post_model.dart';
import '../../models/todo_model.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository userRepository;
  List<Post> _localPosts = [];

  UserDetailBloc({required this.userRepository}) : super(UserDetailInitial()) {
    on<LoadUserDetail>(_onLoadUserDetail);
    on<AddLocalPost>(_onAddLocalPost);
  }

  Future<void> _onLoadUserDetail(
      LoadUserDetail event, Emitter<UserDetailState> emit) async {
    emit(UserDetailLoading());
    try {
      final posts = await userRepository.getUserPosts(event.userId);
      final todos = await userRepository.getUserTodos(event.userId);

      emit(UserDetailLoaded(
        posts: posts.posts ?? [],
        todos: todos.todos ?? [],
        localPosts: _localPosts.where((p) => p.userId == event.userId).toList(),
      ));
    } catch (e) {
      emit(UserDetailError(e.toString()));
    }
  }

  void _onAddLocalPost(AddLocalPost event, Emitter<UserDetailState> emit) {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch,
      title: event.title,
      body: event.body,
      userId: event.userId,
      tags: [],
      views: 0,
    );

    _localPosts.add(newPost);

    if (state is UserDetailLoaded) {
      final currentState = state as UserDetailLoaded;
      emit(currentState.copyWith(
        localPosts: _localPosts.where((p) => p.userId == event.userId).toList(),
      ));
    }
  }
}