import 'package:flutter/material.dart';

mixin Popup {
  Text heading({required String title, TextStyle? style}) => Text(
    title,
    textAlign: TextAlign.center,
    style:
        style ??
        TextStyle(
          fontSize: 16,
          color: Colors.deepOrange[600],
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
    maxLines: null,
    controller: controller,
    readOnly: !isEditing.value,
    onChanged: (value) => {
      if (handleChange != null) {handleChange(value)},
    },
    focusNode: focusNode,
    decoration: InputDecoration(
      border: isEditing.value ? UnderlineInputBorder() : InputBorder.none,
      hintText: text,
    ),

    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  Widget inputContainer({
    String textHint = '',
    required String title,
    Function? handleChange,
    TextEditingController? controller,
    required ValueNotifier<bool> isEditing,
    FocusNode? focusNode,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: heading(title: title)),
        Expanded(
          child: input(
            controller,
            textHint,
            handleChange,
            isEditing,
            focusNode,
          ),
        ),
      ],
    );
  }

  Widget textContainer({
    required String title,
    required String content,
    bool? row = false,
    TextStyle? contentStyle,
  }) {
    final List<Widget> children = [
      heading(title: title),
      heading(
        title: content,
        style:
            contentStyle ??
            TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 12,
            ),
      ),
    ];
    row = row ?? false;
    return row
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: children,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }

  Widget actionBtn({
    required Function handlePress,
    required String name,
    required IconData icon,
    Color? textColor,
    Color? bgColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextButton.icon(
        onPressed: () => handlePress(),
        icon: Icon(icon),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            bgColor ?? Colors.deepOrange[500],
          ),
          iconColor: WidgetStatePropertyAll(Colors.white),
          iconSize: WidgetStatePropertyAll(12),
        ),
        label: Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }

  Widget dialogBox({
    required String popupTitle,
    required List<Widget> content,
    required List<Widget> actions,
  }) {
    return SimpleDialog(
      title: Center(
        child: Text(popupTitle, style: TextStyle(color: Colors.green[600])),
      ),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Colors.black,
      ),

      insetPadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(8),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          spacing: 10,
          children: [
            ...content,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: actions,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// class _PopupState extends State<Popup> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
