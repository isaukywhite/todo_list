import 'package:objectbox/objectbox.dart';

@Entity()
class Todo {
  int id;
  String title;
  bool completed;

  Todo({
    this.id = 0,
    required this.title,
    required this.completed,
  });
}
