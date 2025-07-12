import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/popup.dart';

class NewTaskPopup extends StatefulWidget with Popup {
  const NewTaskPopup({super.key});

  @override
  createState() => _NewTaskPopupState();
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
    final focusNode = FocusNode();
    focusNode.requestFocus();
    return widget.dialogBox(
      popupTitle: 'Add New Task',
      content: [
        widget.inputContainer(
          title: 'Title',
          controller: _titleController,
          textHint: 'Task Title..',
          handleChange: (value) => newTask['title'] = value,
          isEditing: ValueNotifier(true),
          focusNode: focusNode,
        ),
        widget.inputContainer(
          title: 'Description',
          controller: _descriptionController,
          textHint: 'Task Description..',
          handleChange: (value) => newTask['description'] = value,
          isEditing: ValueNotifier(true),
        ),
        widget.textContainer(
          title: 'Created',
          content: newTask['date'],
          row: true,
        ),
      ],
      actions: [
        widget.actionBtn(
          handlePress: () => Navigator.pop(context),
          name: 'Cancel',
          icon: Icons.close_outlined,
        ),
        widget.actionBtn(
          handlePress: () => {
            if (newTask['title'].trim() != '')
              {tasksProvider.addTask(context, newTask)},
            Navigator.pop(context),
          },
          name: 'Add Task',
          icon: Icons.add_outlined,
          bgColor: Colors.green,
        ),
      ],
    );
  }
}
