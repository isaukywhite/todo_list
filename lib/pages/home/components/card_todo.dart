import 'package:flutter/material.dart';

import '../../../modules/todo_database/models/todo.dart';
import '../../../modules/todo_database/todo_database.dart';
import '../home_store.dart';
import 'dialog_alert.dart';

class CardTodo extends StatefulWidget {
  final Todo todo;
  const CardTodo({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<CardTodo> createState() => _CardTodoState();
}

class _CardTodoState extends State<CardTodo> {
  final HomeStore homeStore = HomeStore.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        child: CheckboxListTile(
          title: Text(
            widget.todo.title,
            style: TextStyle(
              fontSize: 19,
              color: Colors.green[900],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          value: widget.todo.completed,
          checkColor: Colors.green[900],
          activeColor: Colors.greenAccent,
          onChanged: (bool? value) {
            if (value == null) return;
            widget.todo.completed = value;
            TodoDatabaseImpl.i.saveTodo(widget.todo);
            homeStore.loadTodos();
          },
        ),
        onLongPress: () {
          DialogAlert(
            title: "Delete Todo",
            content: "Are you sure you want to delete this todo?",
            actions: [
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  TodoDatabaseImpl.i.deleteTodo(widget.todo).then((value) {
                    homeStore.loadTodos();
                  });
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ).show(context);
        },
      ),
    );
  }
}
