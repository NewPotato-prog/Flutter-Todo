import 'package:flutter/material.dart';
import 'package:todo_app/popup.dart';

class ConfirmPopup extends StatefulWidget with Popup {
  const ConfirmPopup({super.key});

  @override
  State<ConfirmPopup> createState() => _ConfirmPopupState();
}

class _ConfirmPopupState extends State<ConfirmPopup> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> confirmActionBtns = [
      widget.actionBtn(
        handlePress: () => Navigator.pop(context, false),
        name: 'Cancel',
        icon: Icons.close_outlined,
        bgColor: Colors.deepOrange,
      ),
      widget.actionBtn(
        handlePress: () => Navigator.pop(context, true),
        name: 'Okay',
        icon: Icons.check_outlined,
        bgColor: Colors.green,
      ),
    ];
    final List<Widget> content = [
      widget.textContainer(title: '', content: 'Mark as completed?'),
    ];
    return widget.dialogBox(
      popupTitle: 'Conformation',
      content: content,
      actions: confirmActionBtns,
    );
  }
}
