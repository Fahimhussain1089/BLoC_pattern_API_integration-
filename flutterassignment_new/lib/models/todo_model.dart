class TodoData {
  List<Todo>? todos;
  int? total;
  int? skip;
  int? limit;

  TodoData({this.todos, this.total, this.skip, this.limit});

  TodoData.fromJson(Map<String, dynamic> json) {
    if (json['todos'] != null) {
      todos = <Todo>[];
      json['todos'].forEach((v) {
        todos!.add(Todo.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }
}

class Todo {
  int? id;
  String? todo;
  bool? completed;
  int? userId;

  Todo({this.id, this.todo, this.completed, this.userId});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    todo = json['todo'];
    completed = json['completed'];
    userId = json['userId'];
  }
}