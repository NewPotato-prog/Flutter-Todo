import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/popup.dart';

class ViewTaskPopup extends StatefulWidget with Popup {
  final Task task;
  const ViewTaskPopup({super.key, required this.task});

  @override
  createState() => _ViewTaskPopupState();
}

class _ViewTaskPopupState extends State<ViewTaskPopup> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final ValueNotifier<bool> isEditing = ValueNotifier(false);
  late final TasksNotifier tasksProvider;
  late final FocusNode titleFocusNode;
  late final Task task;

  @override
  void initState() {
    task = widget.task;
    _titleController = TextEditingController(text: task['title']);
    _descriptionController = TextEditingController(text: task['description']);
    tasksProvider = Provider.of<TasksNotifier>(context, listen: false);

    titleFocusNode = FocusNode();
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
    final List<Widget> editActionBtn = [
      widget.actionBtn(
        handlePress: () => setState(() {
          isEditing.value = !isEditing.value;
        }),
        name: 'Cancel',
        icon: Icons.close_outlined,
      ),
      widget.actionBtn(
        handlePress: () => {
          tasksProvider.updateTask(context, {
            ...task,
            'title': _titleController.text,
            'description': _descriptionController.text,
          }, task['id']),
          Navigator.pop(context),
        },
        name: 'Done',
        icon: Icons.check_box_outlined,
        bgColor: Colors.green,
      ),
    ];

    final List<Widget> viewActionBtn = [
      !task['isCompleted']
          ? widget.actionBtn(
              handlePress: () => setState(() {
                isEditing.value = !isEditing.value;
                titleFocusNode.requestFocus();
              }),
              name: 'Edit',
              icon: Icons.edit_note_outlined,
              bgColor: Colors.green,
            )
          : Container(),
      widget.actionBtn(
        handlePress: () async {
          final bool confirm = await tasksProvider.markCompleted(
            context,
            task['id'],
            task['isCompleted'],
          );
          setState(() {
            if (confirm) task['isCompleted'] = true;
          });
        },
        name: task['isCompleted'] ? 'Completed' : 'Pending',
        icon: task['isCompleted']
            ? Icons.check_box_outlined
            : Icons.timelapse_outlined,
        bgColor: task['isCompleted'] ? Colors.green : Colors.orange,
      ),
      widget.actionBtn(
        handlePress: () => {
          tasksProvider.removeTask(context, task['id']),
          Navigator.pop(context),
        },
        name: 'Delete',
        icon: Icons.delete_forever_outlined,
        bgColor: Colors.deepOrange,
      ),
    ];
    return widget.dialogBox(
      popupTitle: isEditing.value ? 'Edit Task' : 'Task Info',
      content: [
        widget.inputContainer(
          title: 'Title',
          controller: _titleController,
          textHint: task['title'],
          isEditing: isEditing,
          focusNode: titleFocusNode,
        ),
        widget.inputContainer(
          title: 'Description',
          controller: _descriptionController,
          textHint: task['description'] == ''
              ? 'No Description...'
              : task['description'],
          isEditing: isEditing,
        ),
        widget.textContainer(title: 'Created At', content: task['date']),
      ],

      actions: isEditing.value ? editActionBtn : viewActionBtn,
    );
  }
}
