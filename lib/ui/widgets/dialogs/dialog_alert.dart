import 'package:flutter/material.dart';

class DialogAlert extends StatelessWidget {
  final String alertMessage;
  final String alertTitle;
  final Function onOkayPressed;
  final Color? titleColor;

  const DialogAlert(
      {super.key,
      required this.alertMessage,
      required this.onOkayPressed,
      required this.alertTitle, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        alertTitle,
        style: TextStyle(color: titleColor),
      ),
      content: Text(alertMessage),
      actions: [
        TextButton(onPressed: () => onOkayPressed(), child: const Text("Ok"))
      ],
    );
  }
}
