import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';

class NewTaskPopup extends StatefulWidget {
  const NewTaskPopup({super.key});

  @override
  createState() => _NewTaskPopupState();
}

Text heading({required String title, TextStyle? style}) => Text(
  title,
  style:
      style ??
      TextStyle(
        fontSize: 25,
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
);

TextField input(
  TextEditingController? controller,
  String textHint,
  Function? handleChange,
) => TextField(
  controller: controller,
  onChanged: (value) => {
    if (handleChange != null) {handleChange(value)},
  },
  textAlign: TextAlign.center,
  decoration: InputDecoration(hintText: textHint),
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
);

Widget itemContainer({
  String textHint = '',
  required String title,
  Function? handleChange,
  TextEditingController? controller,
}) {
  return Column(
    children: [
      heading(title: title),
      input(controller, textHint, handleChange),
    ],
  );
}

TextButton actionBtn({
  required Function handlePress,
  required String name,
  required IconData icon,
  Color? textColor,
  Color? bgColor,
}) {
  return TextButton.icon(
    onPressed: () => handlePress(),
    icon: Icon(icon),
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(bgColor ?? Colors.orange),
      iconColor: WidgetStatePropertyAll(Colors.white),
      iconSize: WidgetStatePropertyAll(20),
    ),
    label: Text(
      name,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textColor ?? Colors.white,
      ),
    ),
  );
}

class _NewTaskPopupState extends State<NewTaskPopup> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TasksNotifier tasksProvider;
  late final Task newTask;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    tasksProvider = Provider.of<TasksNotifier>(context, listen: false);
    newTask = tasksProvider.createNewTask();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Add New Task')),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.black,
      ),

      actionsPadding: EdgeInsets.all(8),
      insetPadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(5),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          itemContainer(
            title: 'Title',
            controller: _titleController,
            textHint: 'Task Title..',
            handleChange: (value) => newTask['title'] = value,
          ),
          itemContainer(
            title: 'Description',
            controller: _descriptionController,
            textHint: 'Task Description..',
            handleChange: (value) => newTask['description'] = value,
          ),
          heading(title: 'Created At'),
          // or just a simple text with styling, don't need to use heading here..
          heading(
            title: newTask['date'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        actionBtn(
          handlePress: () => Navigator.pop(context),
          name: 'Cancel',
          icon: Icons.close_outlined,
        ),
        actionBtn(
          handlePress: () => {
            if (newTask['title'] != '')
              {tasksProvider.addTask(context, newTask)},
            Navigator.pop(context),
          },
          name: 'Add Task',
          icon: Icons.add_circle_outline,
          bgColor: Colors.green,
        ),
      ],
    );
  }
}
