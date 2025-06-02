import 'package:equatable/equatable.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadUserDetail extends UserDetailEvent {
  final int userId;

  const LoadUserDetail(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddLocalPost extends UserDetailEvent {
  final String title;
  final String body;
  final int userId;

  const AddLocalPost({
    required this.title,
    required this.body,
    required this.userId,
  });

  @override
  List<Object> get props => [title, body, userId];
}