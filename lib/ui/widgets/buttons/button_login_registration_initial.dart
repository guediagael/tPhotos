import 'package:flutter/material.dart';

class ButtonLoginRegistrationInitial extends StatelessWidget {
  final String title;
  const ButtonLoginRegistrationInitial({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:  [const Icon(Icons.send), Text(title)]
    );
  }
}
