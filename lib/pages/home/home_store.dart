import 'package:flutter/material.dart';

import '../../modules/todo_database/models/todo.dart';
import '../../modules/todo_database/todo_database.dart';

class HomeStore {
  HomeStore() {
    loadTodos();
  }
  ValueNotifier<List<Todo>> todos = ValueNotifier<List<Todo>>([]);
  ValueNotifier<bool> recording = ValueNotifier<bool>(false);

  void loadTodos() {
    TodoDatabaseImpl.i.getTodos().then((value) {
      todos.value = value;
    });
  }
}
