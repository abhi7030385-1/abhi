import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        useMaterial3: true,
      ),
      home: const TodoScreen(),
    );
  }
}

class Todo {
  String text;
  bool done;
  Todo({required this.text, this.done = false});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Todo> _todos = [];

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _todos.add(Todo(text: text));
      _controller.clear();
    });
  }

  void _deleteTodo(int index) {
    setState(() => _todos.removeAt(index));
  }

  void _toggleTodo(int index) {
    setState(() => _todos[index].done = !_todos[index].done);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'My Tasks',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Input Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Naya task likho...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14,
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),

          // Todo List
          Expanded(
            child: _todos.isEmpty
                ? const Center(
                    child: Text(
                      'Koi task nahi!\nUpar se add karo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.done,
                            activeColor: const Color(0xFF4F46E5),
                            onChanged: (_) => _toggleTodo(index),
                          ),
                          title: Text(
                            todo.text,
                            style: TextStyle(
                              decoration: todo.done
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: todo.done ? Colors.grey : Colors.black87,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () => _deleteTodo(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Bottom Stats
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statBox('Total', _todos.length),
                _statBox('Done', _todos.where((t) => t.done).length),
                _statBox('Baki', _todos.where((t) => !t.done).length),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, int count) {
    return Column(
      children: [
        Text('$count',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F46E5))),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
