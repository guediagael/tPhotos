import 'package:flutter/material.dart';

class ButtonRetry extends StatelessWidget {
  final Function onRetry;

  const ButtonRetry({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onRetry(),
        child: Row(
          children: const [Icon(Icons.refresh), Text("Refresh")],
        ));
  }
}
