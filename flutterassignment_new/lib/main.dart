// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/user_repository.dart';
import 'bloc/user_list/user_list_bloc.dart';
import 'screens/user_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UserListBloc>(
            create: (context) => UserListBloc(
              userRepository: RepositoryProvider.of<UserRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter User Management',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const UserListScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

/*






lib/
├── main.dart
├── models/
│   ├── user_model.dart (your existing model)
│   ├── post_model.dart
│   └── todo_model.dart
├── repositories/
│   └── user_repository.dart
├── bloc/
│   ├── user_list/
│   │   ├── user_list_bloc.dart
│   │   ├── user_list_event.dart
│   │   └── user_list_state.dart
│   └── user_detail/
│       ├── user_detail_bloc.dart
│       ├── user_detail_event.dart
│       └── user_detail_state.dart
├── screens/
│   ├── user_list_screen.dart
│   ├── user_detail_screen.dart
│   └── create_post_screen.dart
└── widgets/
    ├── user_card.dart
    ├── loading_widget.dart
    └── error_widget.dart



 */