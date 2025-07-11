import 'package:flutter/material.dart';

class InputEl extends StatefulWidget {
  const InputEl({super.key, required this.addTaskFn});
  final Function addTaskFn;

  @override
  State<StatefulWidget> createState() => _InputElState();
}

class _InputElState extends State<InputEl> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Flexible(
          child: TextField(
            controller: controller,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              label: Text('New TODO...'),
              hintText: 'Enter new task..',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: Colors.black38),
              ),
            ),
          ),
        ),

        IconButton(
          icon: Icon(Icons.add_box_rounded, size: 40, color: Colors.black54),
          hoverColor: const Color.fromARGB(160, 64, 195, 255),
          highlightColor: const Color.fromARGB(160, 64, 195, 255),
          onPressed: () => widget.addTaskFn(controller.text),
        ),
      ],
    );
  }
}
