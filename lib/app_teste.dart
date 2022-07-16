import 'package:flutter/material.dart';

import 'modules/speech/speech.dart';
import 'modules/todo_database/models/todo.dart';
import 'modules/todo_database/todo_database.dart';

class AppTeste extends StatelessWidget {
  const AppTeste({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeTeste(),
    );
  }
}

class HomeTeste extends StatefulWidget {
  const HomeTeste({Key? key}) : super(key: key);

  @override
  State<HomeTeste> createState() => _HomeTesteState();
}

class _HomeTesteState extends State<HomeTeste> {
  ValueNotifier<List<Todo>> todos = ValueNotifier<List<Todo>>([]);
  ValueNotifier<bool> recording = ValueNotifier<bool>(false);

  void load() {
    TodoDatabaseImpl.i.getTodos().then((value) {
      todos.value = value;
    });
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Teste'),
      ),
      body: ValueListenableBuilder<List<Todo>>(
        valueListenable: todos,
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (_, int index) {
              final todo = value[index];
              return Card(
                child: Center(
                  child: GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Confirmar'),
                          content: const Text('Deseja excluir o todo?'),
                          actions: [
                            TextButton(
                              child: const Text('Sim'),
                              onPressed: () {
                                TodoDatabaseImpl.i
                                    .deleteTodo(todo)
                                    .then((value) {
                                  load();
                                });
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Não'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                    child: CheckboxListTile(
                      title: Text(todo.title),
                      value: todo.completed,
                      onChanged: (bool? value) {
                        if (value == null) return;
                        todo.completed = value;
                        TodoDatabaseImpl.i.saveTodo(todo);
                        load();
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: recording,
        builder: (_, value, __) {
          return FloatingActionButton(
            onPressed: () async {
              recording.value = true;
              final resp = await SpeechCustom.getText();
              recording.value = false;
              if (resp.isEmpty) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Erro'),
                    content: const Text('Nenhuma palavra foi reconhecida.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                );
                return;
              }
              await TodoDatabaseImpl.i.saveTodo(
                Todo(
                  title: resp,
                  completed: false,
                ),
              );
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('Sucesso'),
                    content: const Text('Tarefa adicionada com sucesso.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                },
              );
              load();
            },
            backgroundColor: recording.value ? Colors.red : Colors.blue,
            child: const Icon(Icons.mic),
          );
        },
      ),
    );
  }
}
