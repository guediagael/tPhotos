import 'package:flutter/material.dart';

class ButtonCancel extends StatelessWidget {

  final Function onCancel;

  const ButtonCancel({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () => onCancel(), child: const Text("Cancel"));
  }
}
