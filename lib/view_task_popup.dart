import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';

class ViewTaskPopup extends StatefulWidget {
  final Task task;
  const ViewTaskPopup({super.key, required this.task});

  @override
  createState() => _ViewTaskPopupState();
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
  String text,
  Function? handleChange,
  ValueNotifier<bool> isEditing, [
  FocusNode? focusNode,
]) => TextField(
  controller: controller,
  enabled: isEditing.value,
  onChanged: (value) => {
    if (handleChange != null) {handleChange(value)},
  },
  focusNode: focusNode,
  decoration: InputDecoration(disabledBorder: InputBorder.none),

  textAlign: TextAlign.center,
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
  required ValueNotifier<bool> isEditing,
  FocusNode? focusNode,
}) {
  return Column(
    children: [
      heading(title: title),
      input(controller, textHint, handleChange, isEditing, focusNode),
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
      actionBtn(
        handlePress: () => setState(() {
          isEditing.value = !isEditing.value;
        }),
        name: 'Cancel',
        icon: Icons.close_outlined,
      ),
      actionBtn(
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
      actionBtn(
        handlePress: () => {
          setState(() {
            tasksProvider.toggleCompleted(context, task['id']);
          }),
        },
        name: task['isCompleted'] ? 'Completed' : 'Pending',
        icon: task['isCompleted']
            ? Icons.check_box_outlined
            : Icons.timelapse_outlined,
        bgColor: task['isCompleted'] ? Colors.green : Colors.orange,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          actionBtn(
            handlePress: () => setState(() {
              isEditing.value = !isEditing.value;
              titleFocusNode.requestFocus();
            }),
            name: 'Edit',
            icon: Icons.edit_note_outlined,
          ),
          actionBtn(
            handlePress: () => {
              tasksProvider.removeTask(context, task['id']),
              Navigator.pop(context),
            },
            name: 'Delete',
            icon: Icons.delete_forever_outlined,
            bgColor: Colors.deepOrange,
          ),
        ],
      ),
    ];
    return AlertDialog(
      title: Center(child: Text('Task Info')),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.black,
      ),

      actionsPadding: EdgeInsets.all(14),
      insetPadding: EdgeInsets.all(4),
      contentPadding: EdgeInsets.all(5),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          itemContainer(
            title: 'Title',
            controller: _titleController,
            textHint: task['title'],
            isEditing: isEditing,
            focusNode: titleFocusNode,
          ),
          itemContainer(
            title: 'Description',
            controller: _descriptionController,
            textHint: task['description'],
            isEditing: isEditing,
          ),
          heading(title: 'Created At'),
          // or just a simple text with styling, don't need to use heading here..
          heading(
            title: task['date'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),

      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowButtonSpacing: 5,
      actions: isEditing.value ? editActionBtn : viewActionBtn,
    );
  }
}
