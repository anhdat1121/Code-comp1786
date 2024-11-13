import 'package:flutter/material.dart';
import '../data/list_data.dart';
import '../models/list_model.dart';
import '../widgets/list_task.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<ListTask> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadAllTasks();
  }

  Future<void> _loadAllTasks() async {
    tasks = await TaskData.instance.readAllTaskData();
    setState(() {});
  }

  void _addUpdateTask({ListTask? task, int? index}) async {
    if (_nameController.text.isEmpty) return;

    final newTask = ListTask(
      name: _nameController.text,
      description: _descriptionController.text,
      date: _selectedDate,
    );

    if (task == null) {
      await TaskData.instance.insertTaskData(newTask);
    } else {
      newTask.id = task.id;
      await TaskData.instance.updateTask(newTask);
    }

    _nameController.clear();
    _descriptionController.clear();
    _selectedDate = DateTime.now();
    _loadAllTasks();
  }

  void _showTaskDialog({ListTask? task, int? index}) {
    if (task != null) {
      _nameController.text = task.name;
      _descriptionController.text = task.description;
      _selectedDate = task.date;
    } else {
      _nameController.clear();
      _descriptionController.clear();
      _selectedDate = DateTime.now();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Task Description'),
              ),
              Row(
                children: [
                  Text('Date: ${formatter.format(_selectedDate)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addUpdateTask(task: task, index: index);
                Navigator.of(context).pop();
              },
              child: Text(task == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _deleteTask(int index) async {
    await TaskData.instance.deleteTask(tasks[index].id!);
    _loadAllTasks();
  }

////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List Application'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Incomplete Tasks'),
              Tab(text: 'Completed Tasks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(isCompleted: false),
            _buildTaskList(isCompleted: true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showTaskDialog(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList({required bool isCompleted}) {
    final filteredTasks =
        tasks.where((task) => task.isCompleted == isCompleted).toList();
    return filteredTasks.isEmpty
        ? const Center(child: Text('No tasks available.'))
        : ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              return ListTaskTile(
                listTask: filteredTasks[index],
                onEdit: () => _showTaskDialog(
                    task: filteredTasks[index],
                    index: tasks.indexOf(filteredTasks[index])),
                onDelete: () =>
                    _deleteTask(tasks.indexOf(filteredTasks[index])),
                onCompleteToggle: (isCompleted) async {
                  final task = filteredTasks[index];
                  final updatedTask = ListTask(
                    id: task.id,
                    name: task.name,
                    description: task.description,
                    date: task.date,
                    isCompleted: isCompleted ?? false,
                  );
                  await TaskData.instance.updateTask(updatedTask);
                  _loadAllTasks();
                },
              );
            },
          );
  }
}
