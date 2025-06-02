import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../bloc/user_detail/user_detail_bloc.dart';
import '../bloc/user_detail/user_detail_event.dart';
import '../bloc/user_detail/user_detail_state.dart';
import '../repositories/user_repository.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'create_post_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final Users user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      )..add(LoadUserDetail(user.id!)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${user.firstName} ${user.lastName}'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePostScreen(userId: user.id!),
              ),
            );
            if (result != null && result is Map<String, String>) {
              context.read<UserDetailBloc>().add(AddLocalPost(
                title: result['title']!,
                body: result['body']!,
                userId: user.id!,
              ));
            }
          },
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<UserDetailBloc, UserDetailState>(
          builder: (context, state) {
            if (state is UserDetailLoading) {
              return const LoadingWidget(message: 'Loading user details...');
            } else if (state is UserDetailLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo(context),
                    const SizedBox(height: 24),
                    _buildPostsSection(context, state),
                    const SizedBox(height: 24),
                    _buildTodosSection(context, state),
                  ],
                ),
              );
            } else if (state is UserDetailError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<UserDetailBloc>().add(LoadUserDetail(user.id!));
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: user.image != null
                  ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user.image!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[600],
                  ),
                ),
              )
                  : Icon(
                Icons.person,
                size: 50,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${user.firstName} ${user.lastName}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.email ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem('Age', '${user.age}'),
                _buildInfoItem('Gender', user.gender ?? ''),
                _buildInfoItem('Phone', user.phone ?? ''),
              ],
            ),
            if (user.address != null) ...[
              const SizedBox(height: 16),
              Text(
                'Address: ${user.address!.address}, ${user.address!.city}',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPostsSection(BuildContext context, UserDetailLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Posts (${state.allPosts.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (state.localPosts.isNotEmpty)
              Chip(
                label: Text('${state.localPosts.length} new'),
                backgroundColor: Colors.green[100],
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (state.allPosts.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('No posts found')),
            ),
          )
        else
          ...state.allPosts.map((post) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          post.title ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (state.localPosts.contains(post))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(post.body ?? ''),
                  if (post.views != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${post.views} views',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )),
      ],
    );
  }

  Widget _buildTodosSection(BuildContext context, UserDetailLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Todos (${state.todos.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (state.todos.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('No todos found')),
            ),
          )
        else
          ...state.todos.map((todo) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                todo.completed == true
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: todo.completed == true ? Colors.green : Colors.grey,
              ),
              title: Text(
                todo.todo ?? '',
                style: TextStyle(
                  decoration: todo.completed == true
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          )),
      ],
    );
  }
}