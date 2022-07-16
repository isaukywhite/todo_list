import 'package:flutter/material.dart';

import 'modules/speech/speech.dart';
import 'modules/todo_database/models/todo.dart';
import 'modules/todo_database/todo_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<Todo>>(
                valueListenable: todos,
                builder: (context, value, _) {
                  return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (ctx, index) {
                        final todo = value[index];
                        return Card(
                          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            child: CheckboxListTile(
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.green[900],
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              value: todo.completed,
                              checkColor: Colors.green[900],
                              activeColor: Colors.greenAccent,
                              onChanged: (bool? value) {
                                if (value == null) return;
                                todo.completed = value;
                                TodoDatabaseImpl.i.saveTodo(todo);
                                load();
                              },
                            ),
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
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: recording,
        builder: (_, value, __) {
          return FloatingActionButton.large(
            child: Icon(
              Icons.mic,
              color: value ? Colors.red : Colors.green[900],
            ),
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
          );
        },
      ),
    );
  }
}
