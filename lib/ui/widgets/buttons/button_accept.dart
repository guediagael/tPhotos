import 'package:flutter/material.dart';

class ButtonAccept extends StatelessWidget {
  final Function onPressed;

  const ButtonAccept({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onPressed(), child: const Text("Ok"));
  }
}
