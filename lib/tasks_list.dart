import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/view_task_popup.dart';

class TasksList extends StatefulWidget {
  final String searchQry;
  const TasksList({super.key, required this.searchQry});

  @override
  State<StatefulWidget> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksNotifier>(context, listen: false);

    Tasks searchResults() {
      return tasksProvider.tasks
          .where(
            (task) =>
                task['title'].contains(widget.searchQry) ||
                task['description'].contains(widget.searchQry),
          )
          .toList();
    }

    final results = searchResults();
    final tasks = results.isEmpty ? tasksProvider.tasks : results;

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        final task = tasks[index];
        bool isCompleted = task['isCompleted'];

        return DecoratedBox(
          decoration: BoxDecoration(),
          child: GestureDetector(
            onTap: () => {
              showDialog(
                context: context,
                builder: (context) {
                  Widget dialog = ViewTaskPopup(task: task);
                  return ChangeNotifierProvider<TasksNotifier>.value(
                    value: tasksProvider,
                    child: dialog,
                  );
                },
              ),
            },
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task['title'],
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: isCompleted
                              ? Colors.black54
                              : Colors.blueAccent,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      Text(task['date']),
                    ],
                  ),
                ),

                TextButton(
                  onPressed: () =>
                      tasksProvider.toggleCompleted(context, task['id']),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      isCompleted ? Colors.green : Colors.orangeAccent,
                    ),
                  ),
                  child: Text(
                    isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Icon(Icons.arrow_right_outlined),
              ],
            ),
          ),
        );
      },
    );
  }
}
