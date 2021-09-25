import 'package:flutter/material.dart';
import 'package:flutter_hive_db/models/todo.dart';
import 'package:flutter_hive_db/todo_tile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _todoController = TextEditingController();

  Future<void> _addTodo() async {
    final todo = Todo(task: _todoController.text, isDone: false);
    await Hive.box<Todo>("todo").add(todo);
    _todoController.text = "";
    Navigator.pop(context);
  }

  Future<void> _deleteTodo(int index) async {
    await Hive.box<Todo>("todo").deleteAt(index);
  }

  Future<void> _toggleTodoState(int index) async {
    final todo = Hive.box<Todo>("todo").getAt(index);
    await Hive.box<Todo>("todo").putAt(
      index,
      Todo(task: todo!.task, isDone: !todo.isDone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter HiveDB"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ValueListenableBuilder<Box<Todo>>(
          valueListenable: Hive.box<Todo>("todo").listenable(),
          builder: (context, todos, child) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos.getAt(index);
                return TodoTile(
                  index: index,
                  task: todo!.task,
                  isDone: todo.isDone,
                  onTap: () => _toggleTodoState(index),
                  onDelete: () => _deleteTodo(index),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16.0))),
            isScrollControlled: true,
            builder: (_) {
              return _buildAddTodoField(context);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddTodoField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Wrap(
        children: [
          TextField(
            controller: _todoController,
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your task here",
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _addTodo,
                child: Text("Done"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
