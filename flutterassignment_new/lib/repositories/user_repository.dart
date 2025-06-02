import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/todo_model.dart';

class UserRepository {
  static const String baseUrl = 'https://dummyjson.com';

  Future<userData> getUsers({int limit = 10, int skip = 0}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users?limit=$limit&skip=$skip'),
      );
      print('📥 Raw API Response: ${response.body}'); // 👈

      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
            print('✅ Parsed JSON: $parsedJson'); // 👈 Logs the decoded JSON object

        return userData.fromJson(json.decode(response.body));


      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<userData> searchUsers(String query, {int limit = 10, int skip = 0}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/search?q=$query&limit=$limit&skip=$skip'),
      );

      if (response.statusCode == 200) {
        return userData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to search users');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<PostData> getUserPosts(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/user/$userId'),
      );

      if (response.statusCode == 200) {
        return PostData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<TodoData> getUserTodos(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/todos/user/$userId'),
      );

      if (response.statusCode == 200) {
        return TodoData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}