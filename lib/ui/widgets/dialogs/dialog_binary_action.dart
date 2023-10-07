import 'package:flutter/material.dart';

class DialogBinaryAction extends StatelessWidget {
  final String alertMessage;
  final String alertTitle;
  final Color? titleColor;
  final Function onPositivePress;
  final Function onNegativePress;

  const DialogBinaryAction(
      {Key? key,
      required this.alertMessage,
      required this.alertTitle,
      required this.onNegativePress,
      required this.onPositivePress,
      this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        alertTitle,
        style: TextStyle(color: titleColor),
      ),
      content: Text(alertMessage),
      actions: [
        TextButton(
            onPressed: () {
              debugPrint("dialog_binary_action::onCancelPressed");
              // Navigator.pop(context, false);
              onNegativePress();
            },
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              debugPrint("dialog_binary_action::onOkayPressed");
              // Navigator.pop(context, true);
              onPositivePress();
            },
            child: const Text("Ok"))
      ],
    );
    ;
  }
}
