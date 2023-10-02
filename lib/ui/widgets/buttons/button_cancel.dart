import 'package:flutter/material.dart';

class ButtonCancel extends StatelessWidget {

  final Function onCancel;

  const ButtonCancel({Key? key, required this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () => onCancel(), child: const Text("Cancel"));
  }
}
