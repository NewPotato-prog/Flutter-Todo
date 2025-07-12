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
      separatorBuilder: (context, index) {
        final task = tasks[index];
        bool isCompleted = task['isCompleted'];

        return Divider(
          color: isCompleted ? Colors.green[800] : Colors.red[700],
        );
      },
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        final task = tasks[index];
        bool isCompleted = task['isCompleted'];

        return GestureDetector(
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task['title'],
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isCompleted
                              ? Colors.black54
                              : Colors.deepOrange[500],
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      Text(task['date'], style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      TextButton(
                        onPressed: () => tasksProvider.markCompleted(
                          context,
                          task['id'],
                          isCompleted,
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            isCompleted ? Colors.green : Colors.orange,
                          ),
                        ),
                        child: Text(
                          isCompleted ? 'Completed' : 'Pending',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      isCompleted
                          ? TextButton(
                              onPressed: () =>
                                  tasksProvider.removeTask(context, task['id']),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Colors.deepOrange,
                                ),
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            )
                          : Container(),
                      Icon(Icons.arrow_right_outlined),
                    ],
                  ),
                ],
              ),
              index == tasks.length - 1
                  ? Divider(
                      color: isCompleted ? Colors.green[800] : Colors.red[700],
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
