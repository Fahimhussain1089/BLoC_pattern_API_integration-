Overview
This Flutter application demonstrates user management with API integration using the BLoC pattern. The app fetches users from DummyJSON API, 
displays them in a paginated list with search functionality, and shows detailed information including posts and todos for each user.

Features
User List with infinite scrolling and pagination

Real-time search by user name

User Details showing:

Basic user information

List of posts

List of todos

Create new posts (local only)

Loading indicators and error handling

Clean BLoC architecture implementation


![WhatsApp Image 2025-06-02 at 09 39 21](https://github.com/user-attachments/assets/b5bd447c-cf83-46d3-9800-66d8a02cff3f)
![WhatsApp Image 2025-06-02 at 09 39 20 (1)](https://github.com/user-attachments/assets/fdeeb2bd-c06e-4dc3-aad4-69e6f9745901)
![WhatsApp Image 2025-06-02 at 09 39 20](https://github.com/user-attachments/assets/956512b3-3d28-44f7-99c7-fa7b8ba3b56b)
![pagination](https://github.com/user-attachments/assets/30c20784-67ee-49da-81e1-1a85f05a5f34)

Architecture
The app follows the BLoC pattern with this structure:



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


    

Key Components:
Models: Data classes for API responses

Repository: Handles API communication

BLoCs: Manage state and business logic

UserListBloc: Handles user list, search, and pagination

UserDetailBloc: Manages user details, posts, and todos

Screens: UI components

Widgets: Reusable UI components

API Integration
The app uses these DummyJSON endpoints:

Users: https://dummyjson.com/users (with pagination via limit and skip)

Search: https://dummyjson.com/users/search?q={query}

Posts: https://dummyjson.com/posts/user/{userId}

Todos: https://dummyjson.com/todos/user/{userId}

Dependencies
flutter_bloc: ^8.1.3

equatable: ^2.0.5

dio: ^5.3.2

cached_network_image: ^3.3.0

Implementation Details
Key Features Implemented:
Pagination: Uses limit and skip parameters for infinite scrolling

Search: Debounced search functionality that queries the API

State Management: Comprehensive BLoC states for loading, success, and error cases

Nested Data Fetching: Posts and todos are fetched when viewing user details

Error Handling: Graceful error display for API failures
