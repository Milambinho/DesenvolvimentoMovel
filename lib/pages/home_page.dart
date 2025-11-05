import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  List<Task> tasks = [];
  String? selectedDate;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks({String? date}) async {
    final loadedTasks = await dbHelper.getTasks(date: date);
    setState(() {
      tasks = loadedTasks;
    });
  }

  Future<void> _addTask() async {
    if (titleCtrl.text.isEmpty) return;
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final task = Task(
      title: titleCtrl.text,
      description: descCtrl.text,
      date: now,
    );
    await dbHelper.insertTask(task);
    titleCtrl.clear();
    descCtrl.clear();
    await _loadTasks();
  }

  Future<void> _toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await dbHelper.updateTask(task);
    await _loadTasks();
  }

  Future<void> _editTask(Task task) async {
    titleCtrl.text = task.title;
    descCtrl.text = task.description;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              task.title = titleCtrl.text;
              task.description = descCtrl.text;
              await dbHelper.updateTask(task);
              if (mounted) Navigator.pop(context);
              await _loadTasks();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _filterByDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      setState(() => selectedDate = formatted);
      await _loadTasks(date: formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _filterByDate,
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => _loadTasks(),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma tarefa ainda!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) {
                final t = tasks[i];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(
                      t.title,
                      style: TextStyle(
                        decoration:
                            t.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      '${t.description}\nData: ${t.date}',
                    ),
                    isThreeLine: true,
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editTask(t),
                        ),
                        IconButton(
                          icon: Icon(
                            t.isDone
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: t.isDone ? Colors.green : null,
                          ),
                          onPressed: () => _toggleDone(t),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleCtrl.clear();
          descCtrl.clear();
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Nova Tarefa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Título'),
                  ),
                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () async {
                    await _addTask();
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
