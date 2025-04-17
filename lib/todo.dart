import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TodoList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Map<String, dynamic>> _todos = [];
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _todos.add({'task': _controller.text, 'done': false});
        _controller.clear();
      });
    }
  }

  void _toggleDone(int index) {
    setState(() {
      _todos[index]['done'] = !_todos[index]['done'];
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ToDo List")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _addTodo, child: const Text("Add")),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      todo['task'],
                      style: TextStyle(
                        decoration: todo['done']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    leading: Checkbox(
                      value: todo['done'],
                      onChanged: (_) => _toggleDone(index),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTodo(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
