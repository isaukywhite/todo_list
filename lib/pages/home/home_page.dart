import 'package:flutter/material.dart';

import '../../modules/speech/speech.dart';
import '../../modules/todo_database/models/todo.dart';
import '../../modules/todo_database/todo_database.dart';
import 'components/card_todo.dart';
import 'components/dialog_alert.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeStore store = HomeStore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<Todo>>(
              valueListenable: store.todos,
              builder: (context, value, _) {
                if (value.isEmpty) {
                  return const Center(
                    child: Text("You don't have any todos yet"),
                  );
                }
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (ctx, index) {
                    final todo = value[index];
                    return CardTodo(todo: todo);
                  },
                );
              },
            ),
          ),
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: store.recording,
        builder: (_, value, __) {
          return FloatingActionButton.large(
            child: Icon(
              Icons.mic,
              color: value ? Colors.red : Colors.green[900],
            ),
            onPressed: () async {
              store.recording.value = true;
              await SpeechCustom.getText().then(
                (resp) {
                  store.recording.value = false;
                  if (resp.isEmpty) {
                    const DialogAlert(
                      title: 'Erro',
                      content: 'Nenhuma palavra foi reconhecida',
                    ).show(context);
                    return;
                  }
                  TodoDatabaseImpl.i
                      .saveTodo(Todo(title: resp, completed: false))
                      .then(
                    (_) {
                      const DialogAlert(
                        title: 'Sucesso',
                        content: 'Todo adicionado com sucesso',
                      ).show(context);
                    },
                  );
                  store.loadTodos();
                },
              );
            },
          );
        },
      ),
    );
  }
}
