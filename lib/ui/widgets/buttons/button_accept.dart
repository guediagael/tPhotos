import 'package:flutter/material.dart';

class ButtonAccept extends StatelessWidget {
  final Function onPressed;

  const ButtonAccept({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onPressed(), child: const Text("Ok"));
  }
}
