import 'package:flutter/material.dart';

class ButtonRetry extends StatelessWidget {
  final Function onRetry;

  const ButtonRetry({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onRetry(),
        child: const Row(
          children: [Icon(Icons.refresh), Text("Refresh")],
        ));
  }
}
