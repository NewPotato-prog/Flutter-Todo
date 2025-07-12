import 'dart:convert';
import 'dart:collection';
import 'package:todo_app/confirm_popup.dart';
import 'package:todo_app/themes.dart';
import 'package:uuid/v1.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/search_el.dart';
import 'package:todo_app/tasks_list.dart';
import 'package:todo_app/new_task_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: ChangeNotifierProvider(
        create: (context) => TasksNotifier(),
        builder: (context, child) => Consumer<TasksNotifier>(
          builder: (context, value, child) => Layout(),
        ),
      ),
    ),
  );
}

typedef Task = Map<String, dynamic>;
typedef Tasks = List<Map<String, dynamic>>;

class TasksNotifier extends ChangeNotifier {
  final Tasks _tasks = [];

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  static final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  Task addTask(BuildContext context, Task newTask) {
    _tasks.add(newTask);
    notifyListeners();
    setTasksToSharedPref(context);
    return newTask;
  }

  Task createNewTask() {
    final String date = DateFormat(
      'EEE, MMM d \'at\' h\':\'m a',
    ).format(DateTime.now());
    final newTask = {
      'id': UuidV1().generate(),
      'date': date,
      'title': '',
      'isCompleted': false,
      'description': '',
    };
    return newTask;
  }

  /* Mainly used by [getTasksFromSharedPref] */
  void replaceAllTasks(Tasks tasks) {
    _tasks.clear();
    _tasks.addAll(tasks);
    notifyListeners();
  }

  void removeTask(BuildContext context, String id) async {
    // Add conformation popup, will return true if confirmed
    /*     final confirm = await showDialog(
      context: context,
      builder: (context) => ConfirmPopup(),
    );
    if (confirm) {
      _tasks.removeWhere((task) => task['id'] == id);
      notifyListeners();
      if (context.mounted) setTasksToSharedPref(context);
    } */
    _tasks.removeWhere((task) => task['id'] == id);
    notifyListeners();
    setTasksToSharedPref(context);
  }

  void updateTask(BuildContext context, Task updatedTask, String id) {
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i]['id'] == id) {
        _tasks[i] = updatedTask;
      }
    }
    notifyListeners();
    setTasksToSharedPref(context);
  }

  Future<bool> markCompleted(
    BuildContext context,
    String id,
    bool isCompleted,
  ) async {
    if (isCompleted) return false;
    final confirm = await showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: TasksNotifier(),
        child: ConfirmPopup(),
      ),
    );
    if (confirm) {
      for (Task task in _tasks) {
        if (task['id'] == id) {
          task['isCompleted'] = true;
        }
      }
      notifyListeners();
      if (context.mounted) setTasksToSharedPref(context);
    }
    return confirm;
  }

  void getTasksFromSharedPref(BuildContext context) async {
    final prefs = await pref;
    final tasks = prefs.getStringList('tasks');
    if (tasks != null) {
      final getTasks = tasks.map((e) {
        final task = jsonDecode(e);
        return {
          'id': task['id'],
          'title': task['title'],
          'date': task['date'],
          'isCompleted': task['isCompleted'],
          'description': task['description'],
        };
      }).toList();
      if (context.mounted) {
        Provider.of<TasksNotifier>(
          context,
          listen: false,
        ).replaceAllTasks(getTasks);
      }
    }
  }

  void setTasksToSharedPref(BuildContext context) async {
    final prefs = await pref;
    if (context.mounted) {
      final tasksString = Provider.of<TasksNotifier>(
        context,
        listen: false,
      )._tasks.map((task) => jsonEncode(task)).toList();

      await prefs.setStringList('tasks', tasksString);
    }
  }
}

class Layout extends StatefulWidget {
  // final Tasks tasksList;
  const Layout({super.key /* required this.tasksList */});

  @override
  createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final searchController = TextEditingController();
  late final ValueNotifier<String> searchQuery;

  @override
  void initState() {
    Provider.of<TasksNotifier>(
      context,
      listen: false,
    ).getTasksFromSharedPref(context);

    searchQuery = ValueNotifier('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TasksNotifier myProvider = Provider.of<TasksNotifier>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
        centerTitle: true,
        titleSpacing: 10,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.green[600],
        ),
      ),

      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          child: Column(
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 5.0),
                child: SearchEl(
                  controller: searchController,
                  handleChange: (value) => {searchQuery.value = value},
                ),
              ),
              Provider.of<TasksNotifier>(
                    context,
                    listen: false,
                  ).tasks.isNotEmpty
                  ? Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: searchQuery,
                        builder: (context, value, child) {
                          return TasksList(searchQry: value);
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        'Tap on + icon below to create new task',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () => {
          showDialog(
            context: context,
            builder: (context) {
              Widget dialog = NewTaskPopup();
              return ChangeNotifierProvider<TasksNotifier>.value(
                value: myProvider,
                child: dialog,
              );
            },
          ),
        },
        icon: Icon(Icons.add_circle_outlined, size: 50, color: Colors.green),
        highlightColor: Color.fromARGB(255, 255, 171, 64),
        focusColor: Color.fromARGB(255, 7, 6, 6),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
