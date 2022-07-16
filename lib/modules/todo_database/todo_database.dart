import '../../objectbox.g.dart';
import 'models/todo.dart';

abstract class TodoDatabase {
  Future<List<Todo>> getTodos();
  Future<int> saveTodo(Todo todo);
  Future<bool> deleteTodo(Todo todo);
}

class TodoDatabaseImpl implements TodoDatabase {
  static final i = TodoDatabaseImpl._();
  TodoDatabaseImpl._() {
    _init();
  }
  bool _loaded = false;
  late Box<Todo> box;

  Future<void> _init() async {
    final store = await openStore();
    box = store.box<Todo>();
    _loaded = true;
  }

  Future<void> loading() async {
    while (!_loaded) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Future<List<Todo>> getTodos() async {
    await loading();
    return box.getAll();
  }

  @override
  Future<int> saveTodo(Todo todo) async {
    await loading();
    return box.put(todo);
  }

  @override
  Future<bool> deleteTodo(Todo todo) async {
    await loading();
    return box.remove(todo.id);
  }
}
